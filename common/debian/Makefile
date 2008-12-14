all:
	apt-ftparchive packages . | gzip -9c > Packages.gz
	apt-ftparchive sources  . | gzip -9c > Sources.gz
	apt-ftparchive contents . | gzip -9c > Contents.gz
	apt-ftparchive release  . > Release
