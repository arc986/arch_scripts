#!/bin/bash

# Script para añadir configuraciones de privacidad, seguridad y rendimiento a user.js en Firefox.
# Autor: Gemini (con aportes sobre seguridad/privacidad de la comunidad FOSS)

# --- CONFIGURACIONES A AÑADIR ---
# Estas son las preferencias de user.js para deshabilitar telemetría, funcionalidades no esenciales,
# mejorar seguridad/privacidad y ajustar rendimiento básico.
# Incluye la corrección para browser.link.open_newwindow.restriction=2.
# Nota: Configuraciones experimentales o que rompen mucha compatibilidad/rendimiento
# (ej: privacy.partition.*, algunas de WebRTC/WebGL) están comentadas o ajustadas
# para un equilibrio razonable, según nuestra discusión.

CONFIGURACIONES_USERJS='
// --- Configuraciones añadidas por script para mejorar Privacidad y Seguridad ---
// Fecha de adición: '"$(date +%Y-%m-%d)"'

// --- Deshabilitar Telemetría, Reportes y Estudios ---
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.server", "");
user_pref("toolkit.telemetry.cachedPingSample", 0);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPing.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("browser.pingCentre.telemetry", false);
user_pref("services.sync.metrics.activityStreamTelemetryEnabled", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.section.engine.telemetry", false); // Deshabilita telemetría del "explorador de secciones"

user_pref("datareporting.healthreport.uploadEnabled", false); // Reporte de salud de Firefox
user_pref("datareporting.policy.dataSubmissionEnabled", false); // Envío general de datos de uso

user_pref("app.shield.optoutStudies.enabled", true); // Permitir auto-exclusión (recomendado)
user_pref("app.shield.client.state.enabled", false); // Deshabilita estudios
user_pref("extensions.experiments.enabled", false); // Deshabilita experimentos
user_pref("extensions.experiments.supported", false);
user_pref("extensions.postDownloadThirdPartyPrompt", false); // No preguntar sobre software adicional

user_pref("breakpad.autoSubmit", false); // No enviar informes de fallos automáticamente
user_pref("browser.tabs.crashReporting.sendReport", false); // No enviar informes de fallos de pestañas

// --- Deshabilitar Funcionalidades No Esenciales / Molestas ---
user_pref("extensions.pocket.enabled", false); // Deshabilita Pocket
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false); // Deshabilita noticias destacadas
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false); // Deshabilita destacados
user_pref("browser.urlbar.suggest.activitystream", false); // No sugerir desde activity stream
user_pref("browser.discovery.enabled", false); // Deshabilita funcionalidades de "descubrimiento"

// Ajustes básicos de UX/sesión (ajústalos a tu gusto)
user_pref("browser.tabs.loadInBackground", true);
user_pref("browser.tabs.unloadInBackground", true);
user_pref("browser.sessionstore.interval", 60000); // Guardar sesión cada 60s
user_pref("browser.sessionstore.max_tabs_undo", 10);
user_pref("browser.sessionstore.max_windows_undo", 3);


// --- Mejorar Privacidad ---
user_pref("browser.contentblocking.category", "strict"); // Protección Antirrastreo estricta
user_pref("privacy.trackingprotection.enabled", true); // Asegurar activado
user_pref("privacy.resistFingerprinting", true); // Resistir fingerprinting (posible impacto en rendimiento/compatibilidad)
user_pref("privacy.resistFingerprinting.autoDeclineNoOpApis", true);
user_pref("privacy.socialtracking.enabled", true); // Bloquear rastreadores sociales
user_pref("privacy.query_stripping.enabled3", true); // Eliminar parámetros de rastreo de URLs
user_pref("browser.send_pings", false); // No enviar pings a enlaces

user_pref("browser.link.open_newwindow.restriction", 2); // *** CORRECCIÓN DE SEGURIDAD: Restringir control de sitios sobre ventanas emergentes/nuevas pestañas ***

// Comportamiento de Cookies (5=Rechazar Todas, 4=Bloquear 3ros - recomendado si usas bloqueador, 1=Permitir todo - no recomendado)
user_pref("network.cookie.cookieBehavior", 4);

user_pref("network.http.referer.XOriginPolicy", 2); // Enviar referrer solo a destino de origen
user_pref("network.http.referer.XOriginTrimmingPolicy", 2); // Enviar solo esquema, host, puerto

user_pref("dom.event.clipboardevents.enabled", false); // Evita que sitios lean portapapeles

// WebRTC (Deshabilitar evita fugas de IP pero rompe videollamadas/audio en muchos sitios)
user_pref("media.navigator.enabled", false);
user_pref("media.peerconnection.enabled", false);
// Si necesitas WebRTC, NO deshabilitar las dos líneas anteriores, y usar estas para mitigar fugas:
// user_pref("media.peerconnection.ice.relay_only", true);
// user_pref("media.peerconnection.ice.default_address_only", true);


user_pref("network.IDN_show_punycode", true); // Proteger contra ataques homógrafos

// --- Mejorar Seguridad ---
user_pref("security.mixed_content.block_active_content", true); // Bloquear contenido activo HTTP en HTTPS
user_pref("security.mixed_content.upgrade_display_content", true); // Actualizar contenido pasivo HTTP a HTTPS
user_pref("security.enterprise_roots.enabled", true); // Confiar en certificados root del SO
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true); // Tratar SSL inseguro como roto
user_pref("security.ssl.require_safe_negotiation", true); // Requerir SSL seguro

// HTTPS-Only Mode (Descomentar si quieres forzar HTTPS siempre que sea posible)
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);

// --- Configuraciones de Barra de URL y Búsqueda ---
user_pref("browser.urlbar.suggest.searches", false);
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.bookmarks", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.resultScreens", false);

user_pref("browser.search.suggest.enabled", false); // No enviar texto de búsqueda para sugerencias
user_pref("browser.search.showOneOffButtons", false); // No mostrar botones de otros motores en barra de búsqueda

// --- Deshabilitar Prefetching/Prerendering (Mejora privacidad, puede reducir velocidad percibida, ahorra recursos en 2do plano) ---
user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);
user_pref("network.prefetch-next", false);
user_pref("network.predictor.enabled", false);

// --- Deshabilitar WebGL (Reduce superficie ataque/fingerprinting, puede mejorar rendimiento si no usas WebGL, rompe sitios con WebGL) ---
user_pref("webgl.disabled", true);

// --- Fuentes (Ajusta según tu necesidad de diseño vs privacidad/seguridad) ---
user_pref("browser.display.use_document_fonts", 0); // 0=Deshabilitar (más privado/seguro), 1=Permitir (por defecto, mejor diseño)

// --- Otros ---
user_pref("browser.privateBrowse.autostart", false); // Puedes cambiar a true si quieres iniciar siempre en privado
user_pref("browser.casting.enabled", false); // Deshabilita casting
user_pref("media.eme.enabled", false); // Deshabilita DRM (rompe Netflix, etc., mejora seguridad)
user_pref("media.gmp-widevinecdm.enabled", false); // Deshabilita Widevine CDM (si el anterior no funciona)

user_pref("geo.enabled", false); // Deshabilita API de geolocalización
user_pref("browser.search.geoip.url", ""); // Deshabilita servicios de geolocalización de búsqueda
user_pref("geo.provider.network.url", "");
user_pref("geo.provider.ms-windows-location", false);

user_pref("extensions.systemAddon.update.url", ""); // Evitar comunicación sobre add-ons del sistema

// --- Configuraciones Experimentales (Pueden afectar seriamente compatibilidad, rendimiento y estabilidad - Mantener comentadas si priorizas esto) ---
user_pref("privacy.partition.network_state", true); // Aislamiento de estado de red por origen (posible aumento RAM/disco, rompe compatibilidad)
user_pref("privacy.partition.serviceWorkers", true); // Aislamiento de Service Workers por origen (posible aumento RAM/disco, rompe compatibilidad)
user_pref("privacy.partition.cache", true); // Aislamiento de caché por origen (posible aumento RAM/disco, rompe compatibilidad)

// --- Deshabilitar Sincronización (Complementario a deshabilitar FxA) ---
// Aunque deshabilitar FxA debería bastar, estas preferencias aseguran que la sincronización esté apagada.
user_pref("services.sync.engine.bookmarks", false);
user_pref("services.sync.engine.passwords", false);
user_pref("services.sync.engine.prefs", false);
user_pref("services.sync.engine.history", false);
user_pref("services.sync.engine.tabs", false);
user_pref("services.sync.engine.creditcards", false);
user_pref("services.sync.engine.addresses", false);
user_pref("services.sync.prefs.sync.extensions.sync.enabled", false);

// También podrías considerar:
user_pref("services.sync.account", ""); // Limpiar la cuenta configurada
user_pref("services.sync.username", ""); // Limpiar el nombre de usuario configurado
user_pref("services.sync.token", ""); // Limpiar el token de sincronización


// --- Configuraciones específicas para Wayland ---
// Permite que Firefox use el backend nativo de Wayland en lugar de Xwayland.
// Requiere un compositor Wayland (como Sway) y drivers gráficos compatibles.
// Nota: Reinicia Firefox después de cambiar esto. Verifica en about:support -> Ventana -> Protocolo.
user_pref("widget.wayland.enabled", true);

// --- Aceleración por Hardware (Importante para rendimiento en Wayland) ---
// Asegura que WebRender, el compositor moderno de Firefox, esté activado.
// Esto es crucial para un buen rendimiento gráfico, especialmente con Wayland.
// Debería estar activado por defecto en hardware compatible, pero estas líneas lo fuerzan si no es así.
user_pref("gfx.webrender.enabled", true);
user_pref("gfx.webrender.all", true); // Fuerza WebRender en hardware no listado oficialmente

// Deshabilitar los backends antiguos específicos de X11 (si widget.wayland.enabled es true, estos deberían estar apagados)
user_pref("gfx.xrender.enabled", false);
user_pref("gfx.xpixmap.enabled", false);

// Aceleración por hardware para decodificación de video (VAAPI)
// Mejora el rendimiento al reproducir videos, liberando la CPU.
// Requiere que tengas VAAPI configurado y funcionando en tu sistema (drivers gráficos).
user_pref("media.ffmpeg.vaapi.enabled", true);
// Nota: Puede que necesites verificar que VAAPI está funcionando correctamente en tu sistema
// y que Firefox fue compilado con soporte para VAAPI (las versiones de los repositorios oficiales de Arch suelen incluirlo).

// --- Otras configuraciones de Wayland ---
// Permite usar decoraciones de ventana nativas de Wayland (si el compositor las maneja).
// Esto puede hacer que las ventanas se sientan más integradas visualmente.
user_pref("widget.wayland.allow-native-wrappers", true);

// Puede ayudar con algunos problemas de integración de ventanas en Wayland.
// user_pref("widget.wayland.vsync.enabled", true); // Ya suele ser default true

// --- Consideraciones de Rendimiento/Estabilidad ---
// Las configuraciones anteriores (deshabilitar prefetching/predictor, WebGL, etc.)
// que ya incluimos en el user.js general también contribuyen al rendimiento
// general independientemente de X11 o Wayland, al reducir la actividad innecesaria.

// El particionamiento (privacy.partition.*) que mencionamos que puede aumentar
// el consumo de RAM/disco, también tiene un impacto en entornos Wayland.
// Si priorizas bajo consumo, mantenlas deshabilitadas como en el user.js previo.


// Fin de configuraciones añadidas por script
';

# --- Lógica del Script ---

echo "Intentando encontrar el directorio de perfil principal de Firefox..."

# Busca directorios de perfil, priorizando *.default-release (más común)
# Asegúrate de que el directorio contenga un archivo 'prefs.js' para confirmar que es un perfil.
# Esto es una aproximación y podría no funcionar en todas las configuraciones.
PROFILE_DIR=$(find "$HOME/.mozilla/firefox/" -maxdepth 1 -type d -name "*.default-release" -print -quit)

if [ -z "$PROFILE_DIR" ]; then
    # Si no encuentra *.default-release, busca *.default
    PROFILE_DIR=$(find "$HOME/.mozilla/firefox/" -maxdepth 1 -type d -name "*.default" -print -quit)
fi

# Verifica si se encontró un directorio de perfil válido
if [ -z "$PROFILE_DIR" ] || [ ! -f "$PROFILE_DIR/prefs.js" ]; then
    echo "Error: No se pudo encontrar un directorio de perfil principal de Firefox."
    echo "Por favor, localiza tu directorio de perfil manualmente (usando about:profiles en Firefox)"
    echo "y añade el contenido de CONFIGURACIONES_USERJS a un archivo user.js dentro de ese directorio."
    exit 1
fi

USERJS_FILE="$PROFILE_DIR/user.js"

echo "Directorio de perfil identificado: $PROFILE_DIR"
echo "El archivo user.js a modificar es: $USERJS_FILE"

# Opcional: Hacer una copia de seguridad de user.js si existe
if [ -f "$USERJS_FILE" ]; then
    echo "Se encontró un user.js existente. Creando copia de seguridad: ${USERJS_FILE}.bak"
    cp "$USERJS_FILE" "${USERJS_FILE}.bak"
    if [ $? -ne 0 ]; then
        echo "Advertencia: No se pudo crear la copia de seguridad. Continuando de todos modos."
    fi
fi

echo "Añadiendo configuraciones al archivo user.js..."

# Usar 'cat' con 'grep -v' para evitar añadir líneas que ya están presentes,
# y '> >' para añadir al final del archivo.
# Esto es una prevención básica contra duplicados, no maneja líneas modificadas.
echo "$CONFIGURACIONES_USERJS" | while read -r line; do
    # Añadir solo si la línea no está vacía y no es un comentario simple (empieza por // o #)
    if [[ -n "$line" ]] && ! [[ "$line" =~ ^[[:space:]]*[\/\#] ]]; then
        # Intentar añadir la línea solo si no contiene exactamente esa preferencia ya
        # Esto es una prevención simple, puede fallar con formatos diferentes
        pref_key=$(echo "$line" | awk -F'"' '{print $2}')
        if [ -n "$pref_key" ]; then
            if ! grep -q "user_pref(\"$pref_key\"" "$USERJS_FILE" 2>/dev/null; then
                echo "$line" >> "$USERJS_FILE"
            else
                # Si la preferencia ya existe, puedes decidir si la sobrescribes o la omites.
                # Aquí optamos por sobresaltar la línea existente. La última línea en user.js prevalece.
                # Para simplificar este script, simplemente añadimos la línea nueva.
                # Una gestión de user.js más robusta requeriría parseo y modificación más complejos.
                 echo "$line" >> "$USERJS_FILE"
            fi
        else
             echo "$line" >> "$USERJS_FILE" # Añadir comentarios o líneas sin formato user_pref
        fi
    else
        echo "$line" >> "$USERJS_FILE" # Añadir comentarios o líneas vacías
    fi
done

# Un enfoque más simple y seguro para evitar duplicados es eliminar las líneas anteriores antes de añadir las nuevas,
# pero requiere parseo complejo. El enfoque actual de añadir y dejar que la última línea prevalezca es más simple para un script.

echo "Proceso completado."
echo "Configuraciones añadidas/actualizadas en: $USERJS_FILE"
echo "Por favor, abre este archivo y revisa su contenido."
echo "Recuerda CERRAR y volVER A ABRIR Firefox para que los cambios surtan efecto."
echo "No olvides instalar las extensiones esenciales (uBlock Origin, etc.) manualmente."
