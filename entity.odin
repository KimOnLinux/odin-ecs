package ecs

import "core:container/queue"

Entity :: distinct uint

Entity_And_Some_Info  :: struct {
  entity: Entity,
  is_valid: bool,
}

Entities :: struct {
  current_entity_id: uint,

  entities: [dynamic]Entity_And_Some_Info,
  available_slots: queue.Queue(uint),
}

create_entity :: proc() -> Entity {
  using world.entities

  if queue.len(available_slots) <= 0 {
    append_elem(&entities, Entity_And_Some_Info{Entity(current_entity_id), true})
    current_entity_id += 1
    return Entity(current_entity_id - 1)
  } else {
    index := queue.pop_front(&available_slots)
    entities[index] = Entity_And_Some_Info{Entity(index), true}
    return Entity(index)
  }

  return Entity(current_entity_id)
}

is_entity_valid :: proc(entity: Entity) -> bool {
  using world.entities
  
  if uint(entity) >= len(entities) {
    return false
  }
  return entities[uint(entity)].is_valid
}

// This is slow. 
// This will be significantly faster when an archetype or sparse set ECS is implemented.
get_entities_with_components :: proc(components: []typeid) -> (entities: [dynamic]Entity) {
  entities = make([dynamic]Entity)

  if len(components) <= 0 {
    return entities
  } else if len(components) == 1 {
    for entity, _ in world.component_map[components[0]].entity_indices {
      append_elem(&entities, entity)
    }
    return entities
  }

  for entity, _ in world.component_map[components[0]].entity_indices {

    has_all_components := true
    for comp_type in components[1:] {
      if !has_component(entity, comp_type) {
        has_all_components = false
        break
      }
    }

    if has_all_components {
      append_elem(&entities, entity)
    }

  }

  return entities
}

destroy_entity :: proc(entity: Entity) {
  using world.entities
  
  for T, component in &world.component_map {
    remove_component_with_typeid(entity, T)
  }

  entities[uint(entity)] = {}
  queue.push_back(&available_slots, uint(entity))
}