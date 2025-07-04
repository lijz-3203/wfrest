add_packages("zlib")
includes("**/xmake.lua")
target("wfrest")
    add_deps("base", "core", "util")
    add_packages("workflow")
    set_kind("$(kind)")

    on_load(function (package)
        local include_path = path.join(get_config("wfrest_inc"), "wfrest")
        if (not os.isdir(include_path)) then
            os.mkdir(include_path)
        end

        os.cp(path.join("$(projectdir)", "src/**.h"), include_path)
        os.cp(path.join("$(projectdir)", "src/**.inl"), include_path)
    end)

    after_build(function (target)
        local lib_dir = get_config("wfrest_lib")
        if (not os.isdir(lib_dir)) then
            os.mkdir(lib_dir)
        end
        shared_suffix = "*.so"
        if is_plat("macosx") then
            shared_suffix = "*.dylib"
        end
        if target:is_static() then
            os.cp(path.join("$(projectdir)", target:targetdir(), "*.a"), lib_dir)
        else
            os.cp(path.join("$(projectdir)", target:targetdir(), shared_suffix), lib_dir)
        end
    end)

    on_install(function (target)
        os.mkdir(path.join(target:installdir(), "include/wfrest"))
        os.mkdir(path.join(target:installdir(), "lib"))
        os.cp(path.join(get_config("wfrest_inc"), "wfrest"), path.join(target:installdir(), "include"))
        shared_suffix = "*.so"
        if is_plat("macosx") then
            shared_suffix = "*.dylib"
        end
        if target:is_static() then
            os.cp(path.join(get_config("wfrest_lib"), "*.a"), path.join(target:installdir(), "lib"))
        else
            os.cp(path.join(get_config("wfrest_lib"), shared_suffix), path.join(target:installdir(), "lib"))
        end
    end)

    after_package(function (target)
        os.mkdir(path.join(target:packagedir(),target:plat(), target:arch(),"$(mode)"))
        os.cp(path.join(get_config("wfrest_inc"), "wfrest"), path.join(target:packagedir(),target:plat(), target:arch(),"$(mode)", "include"))

    end)
