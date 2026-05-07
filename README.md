# logtools <img src="media/logtools_logo.png" align="right" height="200"/>

##### *imagen del wati. siganlo en instagram: @wati.bakan*

Captura stdout/stderr de procesos de compilación durante la instalación de paquetes R,
incluyendo bloques ANTICONF de dependencias de sistema.

## Instalación

```bash
git clone https://github.com/jcaro.cont/logtools
cd logtools
R CMD INSTALL .
```


## Uso

```r
library(logtools)

install_github.savelog("usuario/repo")
get_anticonf()
```

## ¿Por qué?

En Linux, instalar ciertos paquetes R requiere ciertas librerías de sistema. Al no encontrarse, manda un fallo y uno ve un bloque
ANTICONF que indica exactamente qué instalar — pero se pierde en el texto infinito del del log de
compilación/instalacion.

![Ejemplo de bloque ANTICONF](media/anticonf-error.png)

El bloque te dice el nombre del paquete de sistema para tu distro:

```
-----------------------------[ ANTICONF ]-------------------------------
Configuration failed to find the libv8 engine library. Try installing:
 * deb: libv8-dev or libnode-dev (Debian / Ubuntu)
 * rpm: v8-devel (Fedora, EPEL)
 * brew: v8 (OSX)
------------------------------------------------------------------------
```

Con `logtools` ese bloque se captura y se puede recuperar después con `get_anticonf()`,
sin perderlo en el texto infinito de compilación.

## Funciones disponibles

| Función | Equivalente |
|---|---|
| `install.packages.savelog()` | `base::install.packages()` |
| `install_github.savelog()` | `remotes::install_github()` |
| `install_gitlab.savelog()` | `remotes::install_gitlab()` |
| `install_git.savelog()` | `remotes::install_git()` |
| `install_bioc.savelog()` | `remotes::install_bioc()` |
| `install_bitbucket.savelog()` | `remotes::install_bitbucket()` |
| `install_cran.savelog()` | `remotes::install_cran()` |
| `install_local.savelog()` | `remotes::install_local()` |
| `install_url.savelog()` | `remotes::install_url()` |
| `install_version.savelog()` | `remotes::install_version()` |

## Requisitos

- Debian based os
- `gcc` y `r-base-dev` para compilar el código C
- `remotes` para los wrappers de `install_*`
