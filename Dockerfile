FROM sigtom/docker-cent6ssh
MAINTAINER "Tommy Craddock" <tec.thor@gmail.com>

#Update pkgs
RUN yum clean all; yum -y update

#Install prereqs for cobbler, koan, and cobbler-web
RUN yum -y install nano createrepo httpd mkisofs mod_wsgi mod_ssl python-cheetah python-netaddr python-simplejson python-urlgrabber PyYAML rsync syslinux tftp-server yum-utils Django python-simplejson git make python-devel python-setuptools python-cheetah openssl wget mlocate debmirror

#Install EPEL Repo
RUN wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -ivh epel-release-6-8.noarch.rpm

#Install Cobbler
RUN yum -y install cobbler cobbler-web dnsmasq syslinux pykickstart
RUN updatedb

# enable tftp
#RUN sed -i -e 's/\(^.*disable.*=\) yes/\1 no/' /etc/xinetd.d/tftp

# create rsync file
COPY files/rsync /etc/xinetd.d
COPY files/dnsmasq.template /etc/cobbler
COPY files/settings /etc/cobbler
COPY files/modules.conf /etc/cobbler
COPY files/debmirror.conf /etc

RUN service cobblerd start
RUN service httpd start
#RUN service dnsmasq start
RUN service xinetd status
RUN chkconfig cobblerd on
RUN chkconfig httpd on
RUN chkconfig dnsmasq on
RUN chkconfig xinetd on


EXPOSE 22
EXPOSE 69
EXPOSE 80
EXPOSE 25151
CMD ["/bin/bash"]
