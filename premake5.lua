workspace "BWAPICLIWorkspace"
   configurations { "Debug", "Release" }
   platforms { "x86" }

project "BWAPI-CLI"
   kind "SharedLib"
   language "C++"
   clr "On"
   
   -- Use the standard modern toolsets (VS2019/2022 are completely safe)
   toolset "v142" 
   systemversion "10.0" -- Safe to use modern SDKs, the macros below handle OS targeting

   defines { 
      "_CRT_SECURE_NO_WARNINGS", 
      "_CRT_SECURE_NO_DEPRECATE",
      -- CRITICAL: Force the target Win32 Subsystem down to Windows 7 (v6.1)
      "WINVER=0x0601",
      "_WIN32_WINNT=0x0601"
   }

   files { "src/**.h", "src/**.cpp" }
   
   includedirs { 
      "3rdparty/bwapi/include",
      "3rdparty/mono",
      "3rdparty/mono/eglib/src"
   }

   libdirs { "3rdparty/mono/msvc/lib" }

   filter "configurations:Release"
      defines { "NDEBUG" }
      runtime "Release"
      links { "BWAPI.lib", "BWAPILIB.lib", "mono-2.0-sgen.lib" }

   filter "configurations:Debug"
      defines { "DEBUG" }
      runtime "Debug"
      links { "BWAPId.lib", "BWAPILIBd.lib", "mono-2.0-sgen.lib" }

   files { "src/**.h", "src/**.cpp" }
   
   includedirs { 
      "3rdparty/bwapi/include",
      "3rdparty/mono",
      "3rdparty/mono/eglib/src"
   }

   libdirs { 
      "3rdparty/bwapi/lib",
      "3rdparty/mono/msvc/lib" 
   }

   filter "configurations:Release"
      defines { "NDEBUG", "WINVER=0x0501", "_WIN32_WINNT=0x0501" } -- Explicit XP Macros
      runtime "Release"
      links { "BWAPI.lib", "BWAPILIB.lib", "mono-2.0-sgen.lib" }
      buildoptions { "/doc" } -- Forces MSVC to generate structural code comments (.xml)

   filter "configurations:Debug"
      defines { "DEBUG", "WINVER=0x0501", "_WIN32_WINNT=0x0501" }
      runtime "Debug"
      links { "BWAPId.lib", "BWAPILIBd.lib", "mono-2.0-sgen.lib" }

      project "BindingGen"
   kind "ConsoleApp"
   language "C#"
   framework "4.0"

   files { "tools/BindingGen/**.cs" }

   links { 
      "CppSharp", 
      "CppSharp.AST", 
      "CppSharp.Runtime" 
   }

   -- Expose target dependency folders for the compilation environment
   includedirs {
      "3rdparty/bwapi/include",
      "3rdparty/bwta2/include"
   }
