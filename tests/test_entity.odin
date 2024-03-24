package test_ecs

import "core:testing"
import ecs "../"

@test
test_entity :: proc(test: ^testing.T) {
  using ecs
  
  init_ecs()
  defer deinit_ecs()

  entities: [100]Entity
  for i in 0..< len(entities) {
    entities[i] = ecs.create_entity()
    testing.expect_value(test, uint(entities[i]), uint(i)) 

    is_valid := is_entity_valid(entities[i])
    testing.expect(test, is_valid == true, "Entity should be valid!") 
  }

  // Delete the entities. The entities should be put on the available_slots queue, so we can reuse that index later.
  for i in 0..< len(entities) {
    destroy_entity(entities[i])
    is_valid := is_entity_valid(entities[i])
    testing.expect(test, is_valid == false, "Entity should not be valid after deleting an entity!") 
  }

  // The entity ids should be the same since we deleted all of the old entities.
  for i in 0..< len(entities) {
    entities[i] = ecs.create_entity()
    testing.expect_value(test, uint(entities[i]), uint(i)) 
  }

}
