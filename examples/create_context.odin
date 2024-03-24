package examples_ecs

import ecs "../"

main :: proc() {
  // Allocate the structures that the ECS needs to run properly.
  ecs.init_ecs()

  // Free all of the allocated memory. This will cleanup everything.
  defer ecs.deinit_ecs()
}

