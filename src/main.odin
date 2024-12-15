package main

import "base:runtime"
import "core:fmt"
import "vendor:glfw"
import "vendor:vulkan"

WIDTH : i32 : 800
HEIGHT : i32 : 600

instance: vulkan.Instance
window: glfw.WindowHandle
surface: vulkan.SurfaceKHR

init_window :: proc() {
  glfw.Init()

  glfw.WindowHint(glfw.CLIENT_API, glfw.NO_API)
  glfw.WindowHint(glfw.RESIZABLE, glfw.FALSE)

  window = glfw.CreateWindow(WIDTH, HEIGHT, "My window", nil, nil)
}

init_vulkan :: proc() {
  create_instance()
  create_surface()
}


main_loop :: proc() {
  running := true
  for running {
    if glfw.WindowShouldClose(window) {
      running = false
    }
  }
}

cleanup :: proc() {
  vulkan.DestroyInstance(instance, nil)
  vulkan.DestroySurfaceKHR(instance, surface, nil)
  glfw.DestroyWindow(window)
  glfw.Terminate()
}


create_instance :: proc() {
  appInfo: vulkan.ApplicationInfo
  appInfo.sType = vulkan.StructureType.APPLICATION_INFO
  appInfo.pApplicationName = "Hello Vulkan"
  appInfo.applicationVersion = vulkan.MAKE_VERSION(1, 0, 0)
  appInfo.pEngineName = "No engine"
  appInfo.engineVersion = vulkan.MAKE_VERSION(1, 0, 0)
  appInfo.apiVersion = vulkan.API_VERSION_1_0

  createInfo: vulkan.InstanceCreateInfo
  createInfo.sType = vulkan.StructureType.INSTANCE_CREATE_INFO
  createInfo.pApplicationInfo = &appInfo

  extensions:= glfw.GetRequiredInstanceExtensions()
  createInfo.enabledExtensionCount = auto_cast len(extensions)
  createInfo.ppEnabledExtensionNames = raw_data(extensions)
  
  if vulkan.CreateInstance(&createInfo, nil, &instance) != vulkan.Result.SUCCESS {
    panic("failed to create instance")
  }



}

create_surface :: proc() {

}

main :: proc() {
  init_window()
  init_vulkan()
  main_loop()
  cleanup()
}
