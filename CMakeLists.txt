cmake_minimum_required(VERSION 3.16)
project(japp_wasm LANGUAGES C CXX)

if(NOT EMSCRIPTEN)
    message(FATAL_ERROR "This CMakeLists.txt is for Emscripten/WebAssembly SIDE_MODULE=2 builds. Use SCons for native builds.")
endif()

set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS TRUE)
set(CMAKE_SHARED_LIBRARY_SUFFIX ".wasm")
set(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "-sSIDE_MODULE=2 -msimd128 -fwasm-exceptions")
set(CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS "-sSIDE_MODULE=2 -msimd128 -fwasm-exceptions")
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(CMAKE_C_STANDARD 17)
set(CMAKE_CXX_STANDARD 17)

execute_process(
    COMMAND git rev-parse --short HEAD
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    OUTPUT_VARIABLE JAPP_GIT_REV
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET
)
if(NOT JAPP_GIT_REV)
    set(JAPP_GIT_REV "wasm")
endif()

set(JAPP_COMMON_COMPILE_FLAGS
    -O2
    -fPIC
    -msimd128
    -fwasm-exceptions
    -fvisibility=hidden
    -Wno-missing-braces
    -Wno-missing-field-initializers
    -Wno-sign-compare
    -Wno-unused-parameter
    -Wno-char-subscripts
    -Wno-cast-qual
)

set(JAPP_COMMON_DEFINES
    NDEBUG
    NO_SQL
    NO_NOTIFY
    NO_CRASHHANDLER
    NO_GEOIP
    C_ONLY
    "ARCH_STRING=\"wasm32\""
    "JAPP_COMPILER=\"emcc\""
    "REVISION=\"${JAPP_GIT_REV}\""
)

set(JAPP_SIDE_LINK_FLAGS
    -sSIDE_MODULE=2
    -sEXPORTED_FUNCTIONS=_GetModuleAPI,_dllEntry,_vmMain
    -msimd128
    -fwasm-exceptions
)

# --- Bundled static libraries (compiled with -fPIC for SIDE_MODULE linking) ---

add_library(japp_cjson STATIC
    cJSON/cJSON.c
)
target_compile_options(japp_cjson PRIVATE ${JAPP_COMMON_COMPILE_FLAGS} -Wno-implicit-fallthrough)

add_library(japp_semver STATIC
    semver/semver.c
)
target_compile_options(japp_semver PRIVATE ${JAPP_COMMON_COMPILE_FLAGS} -Wno-unused-function)

add_library(japp_lua STATIC
    lua/lapi.c
    lua/lauxlib.c
    lua/lbaselib.c
    lua/lbitlib.c
    lua/lcode.c
    lua/lcorolib.c
    lua/lctype.c
    lua/ldblib.c
    lua/ldebug.c
    lua/ldo.c
    lua/ldump.c
    lua/lfunc.c
    lua/lgc.c
    lua/linit.c
    lua/liolib.c
    lua/llex.c
    lua/lmathlib.c
    lua/lmem.c
    lua/loadlib.c
    lua/lobject.c
    lua/lopcodes.c
    lua/loslib.c
    lua/lparser.c
    lua/lstate.c
    lua/lstring.c
    lua/lstrlib.c
    lua/ltable.c
    lua/ltablib.c
    lua/ltm.c
    lua/lundump.c
    lua/lutf8lib.c
    lua/lvm.c
    lua/lzio.c
)
target_compile_options(japp_lua PRIVATE ${JAPP_COMMON_COMPILE_FLAGS})
target_compile_definitions(japp_lua PRIVATE
    LUA_COMPAT_BITLIB
    LUA_COMPAT_APIINTCASTS
)

# --- cgamewasm32.wasm ---

add_library(cgamewasm32 SHARED
    cgame/cg_chatbox.cpp
    cgame/cg_consolecmds.cpp
    cgame/cg_draw.cpp
    cgame/cg_drawtools.cpp
    cgame/cg_effects.cpp
    cgame/cg_ents.cpp
    cgame/cg_event.cpp
    cgame/cg_info.cpp
    cgame/cg_jappScoreboard.cpp
    cgame/cg_light.cpp
    cgame/cg_localents.cpp
    cgame/cg_luafont.cpp
    cgame/cg_luaitem.cpp
    cgame/cg_lualocalentity.cpp
    cgame/cg_luamenu.cpp
    cgame/cg_luarefentity.cpp
    cgame/cg_luaserver.cpp
    cgame/cg_luatextbox.cpp
    cgame/cg_main.cpp
    cgame/cg_marks.cpp
    cgame/cg_media.cpp
    cgame/cg_newDraw.cpp
    cgame/cg_notify.cpp
    cgame/cg_players.cpp
    cgame/cg_playerstate.cpp
    cgame/cg_predict.cpp
    cgame/cg_q3pScoreboard.cpp
    cgame/cg_saga.cpp
    cgame/cg_scoreboard.cpp
    cgame/cg_servercmds.cpp
    cgame/cg_serverHistory.cpp
    cgame/cg_serverModification.cpp
    cgame/cg_smartentities.cpp
    cgame/cg_snapshot.cpp
    cgame/cg_syscalls.cpp
    cgame/cg_teambinds.cpp
    cgame/cg_trueview.cpp
    cgame/cg_turret.cpp
    cgame/cg_view.cpp
    cgame/cg_weaponinit.cpp
    cgame/cg_weapons.cpp
    cgame/fx_blaster.cpp
    cgame/fx_bowcaster.cpp
    cgame/fx_bryarpistol.cpp
    cgame/fx_demp2.cpp
    cgame/fx_disruptor.cpp
    cgame/fx_flechette.cpp
    cgame/fx_force.cpp
    cgame/fx_heavyrepeater.cpp
    cgame/fx_rocketlauncher.cpp
    game/AnimalNPC.cpp
    game/bg_animTable.cpp
    game/bg_g2_utils.cpp
    game/bg_lua.cpp
    game/bg_luacvar.cpp
    game/bg_luaentity.cpp
    game/bg_luaevent.cpp
    game/bg_luafs.cpp
    game/bg_lualogger.cpp
    game/bg_luaplayer.cpp
    game/bg_luaserialiser.cpp
    game/bg_luavector.cpp
    game/bg_misc.cpp
    game/bg_panimate.cpp
    game/bg_pmove.cpp
    game/bg_saber.cpp
    game/bg_saberLoad.cpp
    game/bg_saga.cpp
    game/bg_slidemove.cpp
    game/bg_threading.cpp
    game/bg_vehicleLoad.cpp
    game/bg_weapons.cpp
    game/FighterNPC.cpp
    game/SpeederNPC.cpp
    game/WalkerNPC.cpp
    JAPP/jp_crashExtra.cpp
    JAPP/jp_promode.cpp
    JAPP/jp_stack.cpp
    JAPP/jp_tokenparser.cpp
    ui/ui_fonts.cpp
    ui/ui_shared.cpp
    qcommon/q_math.cpp
    qcommon/q_shared.cpp
)
set_target_properties(cgamewasm32 PROPERTIES PREFIX "" OUTPUT_NAME "cgamewasm32" SUFFIX ".wasm")
target_include_directories(cgamewasm32 PRIVATE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/cgame ${CMAKE_CURRENT_SOURCE_DIR}/game)
target_compile_options(cgamewasm32 PRIVATE ${JAPP_COMMON_COMPILE_FLAGS} -fvisibility-inlines-hidden)
target_compile_definitions(cgamewasm32 PRIVATE ${JAPP_COMMON_DEFINES} PROJECT_CGAME JPLUA LUA_COMPAT_BITLIB LUA_COMPAT_APIINTCASTS)
target_link_libraries(cgamewasm32 PRIVATE japp_cjson japp_lua japp_semver)
target_link_options(cgamewasm32 PRIVATE ${JAPP_SIDE_LINK_FLAGS})

# --- jampgamewasm32.wasm ---

add_library(jampgamewasm32 SHARED
    game/ai_main.cpp
    game/ai_util.cpp
    game/ai_wpnav.cpp
    game/AnimalNPC.cpp
    game/bg_animTable.cpp
    game/bg_g2_utils.cpp
    game/bg_lua.cpp
    game/bg_luacvar.cpp
    game/bg_luaentity.cpp
    game/bg_luaevent.cpp
    game/bg_luafs.cpp
    game/bg_lualogger.cpp
    game/bg_luaplayer.cpp
    game/bg_luaserialiser.cpp
    game/bg_luavector.cpp
    game/bg_misc.cpp
    game/bg_panimate.cpp
    game/bg_pmove.cpp
    game/bg_saber.cpp
    game/bg_saberLoad.cpp
    game/bg_saga.cpp
    game/bg_slidemove.cpp
    game/bg_threading.cpp
    game/bg_vehicleLoad.cpp
    game/bg_weapons.cpp
    game/FighterNPC.cpp
    game/g_active.cpp
    game/g_admin.cpp
    game/g_arenas.cpp
    game/g_bot.cpp
    game/g_chatFilters.cpp
    game/g_client.cpp
    game/g_clientModification.cpp
    game/g_cmds.cpp
    game/g_combat.cpp
    game/g_exphysics.cpp
    game/g_geoip.cpp
    game/g_ICARUScb.cpp
    game/g_items.cpp
    game/g_log.cpp
    game/g_luamysql.cpp
    game/g_luasqlite.cpp
    game/g_luaweapon.cpp
    game/g_main.cpp
    game/g_mem.cpp
    game/g_misc.cpp
    game/g_missile.cpp
    game/g_mover.cpp
    game/g_nav.cpp
    game/g_navnew.cpp
    game/g_object.cpp
    game/g_playerbans.cpp
    game/g_saga.cpp
    game/g_session.cpp
    game/g_smartentities.cpp
    game/g_spawn.cpp
    game/g_svcmds.cpp
    game/g_syscalls.cpp
    game/g_target.cpp
    game/g_team.cpp
    game/g_timer.cpp
    game/g_trigger.cpp
    game/g_turret.cpp
    game/g_turret_G2.cpp
    game/g_unlagged.cpp
    game/g_utils.cpp
    game/g_vehicles.cpp
    game/g_vehicleTurret.cpp
    game/g_weapon.cpp
    game/NPC.cpp
    game/NPC_AI_Atst.cpp
    game/NPC_AI_Default.cpp
    game/NPC_AI_Droid.cpp
    game/NPC_AI_GalakMech.cpp
    game/NPC_AI_Grenadier.cpp
    game/NPC_AI_Howler.cpp
    game/NPC_AI_ImperialProbe.cpp
    game/NPC_AI_Interrogator.cpp
    game/NPC_AI_Jedi.cpp
    game/NPC_AI_Mark1.cpp
    game/NPC_AI_Mark2.cpp
    game/NPC_AI_MineMonster.cpp
    game/NPC_AI_Rancor.cpp
    game/NPC_AI_Remote.cpp
    game/NPC_AI_Seeker.cpp
    game/NPC_AI_Sentry.cpp
    game/NPC_AI_Sniper.cpp
    game/NPC_AI_Stormtrooper.cpp
    game/NPC_AI_Utils.cpp
    game/NPC_AI_Wampa.cpp
    game/NPC_behavior.cpp
    game/NPC_combat.cpp
    game/NPC_goal.cpp
    game/NPC_misc.cpp
    game/NPC_move.cpp
    game/NPC_reactions.cpp
    game/NPC_senses.cpp
    game/NPC_sounds.cpp
    game/NPC_spawn.cpp
    game/NPC_stats.cpp
    game/NPC_utils.cpp
    game/SpeederNPC.cpp
    game/tri_coll_test.cpp
    game/w_force.cpp
    game/w_saber.cpp
    game/WalkerNPC.cpp
    JAPP/jp_crash.cpp
    JAPP/jp_promode.cpp
    JAPP/jp_stack.cpp
    JAPP/jp_tokenparser.cpp
    qcommon/md5.cpp
    qcommon/q_math.cpp
    qcommon/q_shared.cpp
)
set_target_properties(jampgamewasm32 PROPERTIES PREFIX "" OUTPUT_NAME "jampgamewasm32" SUFFIX ".wasm")
target_include_directories(jampgamewasm32 PRIVATE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/game)
target_compile_options(jampgamewasm32 PRIVATE ${JAPP_COMMON_COMPILE_FLAGS} -fvisibility-inlines-hidden)
target_compile_definitions(jampgamewasm32 PRIVATE ${JAPP_COMMON_DEFINES} PROJECT_GAME JPLUA LUA_COMPAT_BITLIB LUA_COMPAT_APIINTCASTS)
target_link_libraries(jampgamewasm32 PRIVATE japp_cjson japp_lua japp_semver)
target_link_options(jampgamewasm32 PRIVATE ${JAPP_SIDE_LINK_FLAGS})

# --- uiwasm32.wasm ---

add_library(uiwasm32 SHARED
    game/bg_animTable.cpp
    game/bg_misc.cpp
    game/bg_saberLoad.cpp
    game/bg_saga.cpp
    game/bg_threading.cpp
    game/bg_vehicleLoad.cpp
    game/bg_weapons.cpp
    JAPP/jp_crash.cpp
    JAPP/jp_tokenparser.cpp
    ui/ui_atoms.cpp
    ui/ui_cvar.cpp
    ui/ui_fonts.cpp
    ui/ui_force.cpp
    ui/ui_gameinfo.cpp
    ui/ui_main.cpp
    ui/ui_saber.cpp
    ui/ui_shared.cpp
    ui/ui_syscalls.cpp
    qcommon/q_math.cpp
    qcommon/q_shared.cpp
)
set_target_properties(uiwasm32 PROPERTIES PREFIX "" OUTPUT_NAME "uiwasm32" SUFFIX ".wasm")
target_include_directories(uiwasm32 PRIVATE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/ui ${CMAKE_CURRENT_SOURCE_DIR}/game)
target_compile_options(uiwasm32 PRIVATE ${JAPP_COMMON_COMPILE_FLAGS} -fvisibility-inlines-hidden)
target_compile_definitions(uiwasm32 PRIVATE ${JAPP_COMMON_DEFINES} PROJECT_UI)
target_link_libraries(uiwasm32 PRIVATE japp_cjson)
target_link_options(uiwasm32 PRIVATE ${JAPP_SIDE_LINK_FLAGS})
