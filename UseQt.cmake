function(eth_apply TARGET REQURIED SUBMODULE)

if (${SUBMODULE} STREQUAL "Core")
	find_package(Qt5Core ${ETH_QT_VERSION} ${REQUIRED})
	if (NOT Qt5Core_FOUND)
		return()
	endif()

	set(Qt5Core_VERSION_MAJOR ${Qt5Core_VERSION_MAJOR} PARENT_SCOPE)
	set_target_properties(${EXECUTABLE} PROPERTIES AUTOMOC ON)
	if (APPLE)
		set (MACDEPLOYQT_APP ${Qt5Core_DIR}/../../../bin/macdeployqt)
		message(" - macdeployqt path: ${MACDEPLOYQT_APP}")
	endif()
	# we need to find path to windeployqt on windows
	if (WIN32)
		set (WINDEPLOYQT_APP ${Qt5Core_DIR}/../../../bin/windeployqt)
		message(" - windeployqt path: ${WINDEPLOYQT_APP}")
	endif()

	if (APPLE)
		find_program(ETH_APP_DMG appdmg)
		message(" - appdmg location : ${ETH_APP_DMG}")
	endif()

	if (("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang") AND NOT (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "3.6") AND NOT APPLE)
		# Supress warnings for qt headers for clang+ccache
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-inconsistent-missing-override")
	endif ()
	target_link_libraries(${TARGET} Qt5::Core)
	if (APPLE AND (NOT "${Qt5Core_VERSION_STRING}" VERSION_LESS "5.5"))
		find_package(Qt5DBus ${ETH_QT_VERSION} ${REQUIRED})
		target_link_libraries(${EXECUTABLE} Qt5::DBus)
	endif()
endif()

if (${SUBMODULE} STREQUAL "Widgets")
	eth_use(${TARGET} ${REQUIRED} Qt::Core)
	find_package(Qt5Widgets ${ETH_QT_VERSION} ${REQUIRED})
	if (NOT Qt5Widgets_FOUND)
		return()
	endif()
	set(Qt5Core_VERSION_MAJOR ${Qt5Widgets_VERSION_MAJOR} PARENT_SCOPE)
	set_target_properties(${EXECUTABLE} PROPERTIES AUTOUIC ON)
	target_link_libraries(${TARGET} Qt5::Widgets)
	if (APPLE AND (NOT "${Qt5Core_VERSION_STRING}" VERSION_LESS "5.5"))
		find_package(Qt5PrintSupport ${ETH_QT_VERSION} ${REQUIRED})
		target_link_libraries(${EXECUTABLE} Qt5::PrintSupport)
	endif()
endif()

if (${SUBMODULE} STREQUAL "WebEngine")
	eth_use(${TARGET} ${REQUIRED} Qt::Core)
	find_package(Qt5WebEngine ${ETH_QT_VERSION} ${REQUIRED})
	if (NOT Qt5WebEngine_FOUND)
		return()
	endif()
	target_link_libraries(${TARGET} Qt5::WebEngine)
	if (APPLE AND (NOT "${Qt5Core_VERSION_STRING}" VERSION_LESS "5.5"))
		find_package(Qt5WebEngineCore ${ETH_QT_VERSION} ${REQUIRED})
		target_link_libraries(${EXECUTABLE} Qt5::WebEngineCore)
	endif()
endif()

if (${SUBMODULE} STREQUAL "WebEngineWidgets")
	eth_use(${TARGET} ${REQUIRED} Qt::Widgets)
	find_package(Qt5WebEngineWidgets ${ETH_QT_VERSION} ${REQUIRED})
	if (NOT Qt5WebEngineWidgets_FOUND)
		return()
	endif()
	target_link_libraries(${TARGET} Qt5::WebEngineWidgets)
endif()

endfunction()
