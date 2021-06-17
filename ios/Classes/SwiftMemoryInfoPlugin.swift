import Flutter
import UIKit

public class SwiftMemoryInfoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "memory_info", binaryMessenger: registrar.messenger())
    let instance = SwiftMemoryInfoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    var pagesize: vm_size_t = 0

    let host_port: mach_port_t = mach_host_self()
    var host_size: mach_msg_type_number_t = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.stride / MemoryLayout<integer_t>.stride)
    host_page_size(host_port, &pagesize)

    var vm_stat: vm_statistics = vm_statistics_data_t()
    withUnsafeMutablePointer(to: &vm_stat) { (vmStatPointer) -> Void in
        vmStatPointer.withMemoryRebound(to: integer_t.self, capacity: Int(host_size)) {
            if (host_statistics(host_port, HOST_VM_INFO, $0, &host_size) != KERN_SUCCESS) {
                NSLog("Error: Failed to fetch vm statistics")
            }
        }
    }
    if call.method == PluginMethods.getPlatformVersion.rawValue{
        result("iOS " + UIDevice.current.systemVersion)
    }
    if call.method == PluginMethods.getFreeMemoryInGB.rawValue{
        let mem_free: Int = Int(vm_stat.free_count) * Int(pagesize)
        result(Double(mem_free)/(1000000000.0))

    }
    if call.method == PluginMethods.getUsedMemoryInGB.rawValue{
        let mem_used: Int = Int(vm_stat.active_count +
                vm_stat.inactive_count +
                vm_stat.wire_count) * Int(pagesize)
        result(Double(mem_used)/(1000000000.0))
    }
  }
}
