
$(if $(strip $(shell [ 'root' = $${USER} ] && echo 1 )),$(info you should NOT run by root)$(error xxx))

define EOL


endef

#	https://golang.org/dl/
#	https://dl.google.com/go/go1.12.8.linux-amd64.tar.gz
verSion:=1.12.8
pkgNameBase:=go$(verSion).linux-amd64
pkgNameAll:=$(pkgNameBase).tar.gz

all:

include Makefile.env

root:
	@echo ;echo "$${rootText}" ; echo

git :
	git config --global core.fileMode 				false
	git config --global core.editor 				vim
	git config --global user.email 					"you@example.com"
	git config --global user.name 					"Your Name"
	git config --global pack.windowMemory           "32m"
	git config --global pack.packSizeLimit          "33m"
	git config --global pack.deltaCacheSize         "34m"
	git config --global pack.threads                "1"
	git config --global core.packedGitLimit         "35m"
	git config --global core.packedGitWindowSize    "36m"
	git config --global http.postbuffer             "5m"
	git repack -a -d --window-memory 10m --max-pack-size 50m

gitX:
	swapoff                /swapfile || echo
	#dd if=/dev/zero     of=/swapfile bs=1024 count=1048576
	dd if=/dev/zero     of=/swapfile bs=1024 count=4194304
	chmod 600              /swapfile
	mkswap                 /swapfile
	swapon                 /swapfile

up:
	nice -n 19 git push -u origin master
e:
	vim Makefile.env
m:
	vim Makefile
gs:
	nice -n 19 git status
gc:
	nice -n 19 git commit -a
	

gd :
	nice -n 19 git diff

ga :
	nice -n 19 git add .
rp:
	@echo nice -n 19 git repack -a -d --window-memory 10m --max-pack-size 20m
	nice -n 19 git config pack.windowMemory 10m
	nice -n 19 git config pack.packSizeLimit 20m


existHugo:=$(strip $(firstword $(wildcard scripts.Hugo/config.toml config.toml)))

$(if $(existHugo),$(eval UseHugo:=1),$(eval UseTree:=1))

############################################### UseHugo  start
############################################### UseHugo  start
############################################### UseHugo  start
ifdef    UseHugo

rg:regen
regen:
	[ -f scripts.Hugo/config.toml ] && make regenX -C scripts.Hugo || make regenX 
#	[ -d themes ] || echo "you should run : git clone https://marstool@github.com/marstool/themes.git"
#	[ -d themes ] || git clone https://marstool@github.com/marstool/themes.git
regenX:
	[ -d themes ] || rsync -a ../../themes/  themes/
	cd themes && git pull
	[ -L public ] || ln -s ../public/
	rm -fr public/*
	rm -fr resources/_gen/*
	cp ../CNAME public/
	[ -f public/CNAME ] || ( echo ; echo "why no CNAME ? exit" ; echo ; exit 32 )
	nice -n 19 hugo

s : server
server:
	[ -d themes ] || echo "you should run : git clone https://marstool@github.com/marstool/themes.git"
	[ -f scripts.Hugo/config.toml ] && make serverX -C scripts.Hugo || make serverX 
serverX:
	nice -n 19 hugo server --disableFastRender
#	nice -n 19 hugo server

# hddps://themes.gohugo.io/
# hddps://gohugo.io/themes/

s2: server2
server2:
	[ -f scripts.Hugo/config.toml ] && make server2X -C scripts.Hugo || make server2X 
server2X:
	cd public/ && python -m SimpleHTTPServer 33221


define help_textHU

	rg -> regen   : regen all hugo
	s  -> server  : run hugo   server to test local
	s2 -> server2 : run python server to test local

endef
export help_textHU


endif
############################################### UseHugo  end
############################################### UseHugo  end
############################################### UseHugo  end


define rootText

useradd gogo
mkdir -p /home/g /home/gogo
chmod -R 755 /home/g 
chmod -R 700 /home/gogo

for aa1 in go gofmt ; do echo ln -s /home/g/bin/$${aa1} /bin/ ; done

endef
export rootText

dd download:
	wget -c https://dl.google.com/go/go$(verSion).linux-amd64.tar.gz
ee extract:
	mkdir -p /home/g/gD/
	rm -fr   /home/g/gD/$(pkgNameBase) 
	rm -fr   /home/g/gD/go
	rm -f    /home/g/gD/nowDIR
	cat $(pkgNameAll) |gunzip |(cd /home/g/gD/ && tar xf - )
	cd /home/g/gD/ && mv go $(pkgNameBase) 
	cd /home/g/gD/ && ln -s  $(pkgNameBase)  nowDIR

linkList1:=go  godoc  gofmt
linkList2:=gomobile gobind
ln link:
	mkdir -p /home/g/bin/
	$(foreach aa1,$(linkList1),cd /home/g/bin/ && rm -f $(aa1) && ln -s ../gD/nowDIR/bin/$(aa1) ./ $(EOL))
	$(foreach aa1,$(linkList2),cd /home/g/bin/ && rm -f $(aa1) && ln -s ../go/bin/$(aa1) ./ $(EOL))
	[ -d /home/g/go ] || (cd /home/gogo/ && mv go /home/g/ )
	rm -f /home/gogo/go 
	ln -s /home/g/go/    /home/gogo/go
	cd /home/g/ && (chmod -R g-w bin gD go  )
	cd /home/g/ && (chmod -R o-w bin gD go  )
	cd /home/g/bin/ && ls -l

gm11 gomobile_install :
	/home/g/bin/go get -u -v golang.org/x/mobile/cmd/gomobile
	/home/g/bin/go get -u -v golang.org/x/mobile/cmd/gobind
gm12 go_used_in_lightsock:
	/home/g/bin/go get -u -v github.com/mitchellh/go-homedir
	/home/g/bin/go get -u -v github.com/phayes/freeport
gm51 gomobile_init :
	/home/g/bin/gomobile init

define ndk1text

https://github.com/golang/go/wiki/Mobile

1. goto	https://developer.android.com/ndk/downloads/
2. download android-ndk-r20
3. extract android-ndk-r20
4. to compress it, use the NdkMount.mksquashfs to compress the directory into img
   mksquashfs ndk-toolchains/    ndk-toolchains.mksquashfs     -comp xz -b 1M

endef
export ndk1text

ndk1 :
	@echo "$${ndk1text}"

define sdk1text

https://developer.android.com/studio#Other
https://dl.google.com/dl/android/studio/ide-zips/3.4.2.0/android-studio-ide-183.5692245-linux.tar.gz
  wget -c https://dl.google.com/dl/android/studio/ide-zips/3.4.2.0/android-studio-ide-183.5692245-linux.tar.gz
  tar xfz ../android-studio-ide-183.5692245-linux.tar.gz 
  mksquashfs android-studio/    android-studio.mksquashfs     -comp xz -b 1M
  rm android-studio -fr
  mv android-studio.mksquashfs android-studio-ide-183.5692245-linux.tar.gz.mksquashfs
  ln -s android-studio-ide-183.5692245-linux.tar.gz.mksquashfs android-studio.mksquashfs
  rm android-studio-ide-183.5692245-linux.tar.gz
  mv android-studio* /home/g/androidNDK/

endef
export sdk1text

sdk1 :
	@echo "$${sdk1text}"






help_text9=$(if $(help_textTV),$(help_textTV),$(if $(help_textHU),$(help_textHU),$(help_textINDEX)))
export help_text9

all:
	@echo "$${help_text9}"

env :
	@echo
	export     ANDROID_HOME=/home/g/sdk_
	export ANDROID_NDK_HOME=/home/g/ndk_
	@echo
