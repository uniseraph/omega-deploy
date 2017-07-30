FROM frolvlad/alpine-oraclejdk8:latest

ADD ./jce_policy-8.zip  /root
RUN cd /root && unzip jce_policy-8.zip && \
     cp -f  UnlimitedJCEPolicyJDK8/local_policy.jar /usr/lib/jvm/java-8-oracle/jre/lib/security  && \
     cp -f UnlimitedJCEPolicyJDK8/US_export_policy.jar  /usr/lib/jvm/java-8-oracle/jre/lib/security

