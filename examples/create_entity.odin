package examples_ecs

import ecs "../"
import "core:fmt"

main :: proc() {
  ecs.init_ecs()
  defer ecs.deinit_ecs()

  // This will return a id(number) that we use internally.
  entity := ecs.create_entity()
  fmt.println("Created entity:", entity)
  // Optional, depending on your usage.
  defer ecs.destroy_entity(entity)
}

