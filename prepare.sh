#!/bin/bash
JSF_MODULE=$1

# 

JSF_VERSION=$(echo $JSF_MODULE | awk -F- '{print $NF}')
JSF_NAME=${JSF_MODULE/-$JSF_VERSION/}

# Static paths
INJECTION_SOURCE_PATH="$EAP_HOME/modules/system/layers/base/org/jboss/as/jsf-injection/main"
INJECTION_TARGET_PATH="$EAP_HOME/modules/org/jboss/as/jsf-injection/${JSF_MODULE}"
WILDFLY_JSF_INJECTION_VERSION=$(find $INJECTION_SOURCE_PATH -name "wildfly-jsf-injection-*" -exec sh -c 'echo $(basename {})' \; | grep -Po '(\d+\.)+.*[^(.jar)]')
WELD_CORE_VERSION=$(find $INJECTION_SOURCE_PATH -name "weld-core-jsf-*" -exec sh -c 'echo $(basename {})' \; | grep -Po '(\d+\.)+.*[^(.jar)]')

API_INSTALL_PATH="${EAP_HOME}/modules/javax/faces/api/${JSF_MODULE}/"
IMPL_INSTALL_PATH="${EAP_HOME}/modules/com/sun/jsf-impl/${JSF_MODULE}/"

MOJARRA_API_JAR_URL="http://central.maven.org/maven2/com/sun/faces/jsf-api/${JSF_VERSION}/jsf-api-${JSF_VERSION}.jar"
MOJARRA_IMPL_JAR_URL="http://central.maven.org/maven2/com/sun/faces/jsf-impl/${JSF_VERSION}/jsf-impl-${JSF_VERSION}.jar"
MOJARRA_IMPL_MODULE="<?xml version=\"1.0\" encoding=\"UTF-8\"?> <module xmlns=\"urn:jboss:module:1.1\" name=\"com.sun.jsf-impl\" slot=\"${JSF_MODULE}\"> <properties> <property name=\"jboss.api\" value=\"private\"/> </properties> <dependencies> <module name=\"javax.faces.api\" slot=\"${JSF_MODULE}\"/> <module name=\"javaee.api\"/> <module name=\"javax.servlet.jstl.api\"/> <module name=\"org.apache.xerces\" services=\"import\"/> <module name=\"org.apache.xalan\" services=\"import\"/> <module name=\"javax.xml.rpc.api\"/> <module name=\"javax.rmi.api\"/> <module name=\"org.omg.api\"/> </dependencies> <resources> <resource-root path=\"jsf-impl-${JSF_VERSION}.jar\"/> </resources> </module>"
MOJARRA_API_MODULE="<?xml version=\"1.0\" encoding=\"UTF-8\"?><module xmlns=\"urn:jboss:module:1.1\" name=\"javax.faces.api\" slot=\"${JSF_MODULE}\"><dependencies><module name=\"com.sun.jsf-impl\" slot=\"${JSF_MODULE}\"/><module name=\"javax.enterprise.api\" export=\"true\"/><module name=\"javax.servlet.api\" export=\"true\"/><module name=\"javax.servlet.jsp.api\" export=\"true\"/><module name=\"javax.servlet.jstl.api\" export=\"true\"/><module name=\"javax.validation.api\" export=\"true\"/><module name=\"org.glassfish.javax.el\" export=\"true\"/><module name=\"javax.api\"/></dependencies><resources><resource-root path=\"jsf-api-${JSF_VERSION}.jar\"/></resources></module>"
MOJARRA_INJECTION_MODULE="<?xml version=\"1.0\" encoding=\"UTF-8\"?> <module xmlns=\"urn:jboss:module:1.1\" name=\"org.jboss.as.jsf-injection\" slot=\"${JSF_MODULE}\"> <properties> <property name=\"jboss.api\" value=\"private\"/> </properties> <resources> <resource-root path=\"wildfly-jsf-injection-${WILDFLY_JSF_INJECTION_VERSION}.jar\"/> <resource-root path=\"weld-core-jsf-${WELD_CORE_VERSION}.jar\"/> </resources> <dependencies> <module name=\"com.sun.jsf-impl\" slot=\"${JSF_MODULE}\"/> <module name=\"javax.api\"/> <module name=\"org.jboss.as.web-common\"/> <module name=\"javax.servlet.api\"/> <module name=\"org.jboss.as.ee\"/> <module name=\"javax.enterprise.api\"/> <module name=\"org.jboss.logging\"/> <module name=\"org.jboss.weld.core\"/> <module name=\"javax.faces.api\" slot=\"${JSF_MODULE}\"/> </dependencies> </module>"

MYFACES_API_JAR_URL="http://central.maven.org/maven2/org/apache/myfaces/core/myfaces-api/${JSF_VERSION}/myfaces-api-${JSF_VERSION}.jar"
MYFACES_IMPL_JAR_URL="http://central.maven.org/maven2/org/apache/myfaces/core/myfaces-impl/${JSF_VERSION}/myfaces-impl-${JSF_VERSION}.jar"
MYFACES_IMPL_MODULE=" <?xml version=\"1.0\" encoding=\"UTF-8\"?> <module xmlns=\"urn:jboss:module:1.1\" name=\"com.sun.jsf-impl\" slot=\"${JSF_MODULE}\"> <properties> <property name=\"jboss.api\" value=\"private\"/> </properties> <dependencies> <module name=\"javax.faces.api\" slot=\"${JSF_MODULE}\"> <imports> <include path=\"META-INF/**\"/> </imports> </module> <module name=\"javaee.api\"/> <module name=\"javax.servlet.jstl.api\"/> <module name=\"org.apache.xerces\" services=\"import\"/> <module name=\"org.apache.xalan\" services=\"import\"/> <module name=\"javax.xml.rpc.api\"/> <module name=\"javax.rmi.api\"/> <module name=\"org.omg.api\"/> </dependencies> <resources> <resource-root path=\"${JSF_NAME}-impl-${JSF_VERSION}.jar\"/> </resources> </module>"
MYFACES_API_MODULE="<?xml version=\"1.0\" encoding=\"UTF-8\"?><module xmlns=\"urn:jboss:module:1.1\" name=\"javax.faces.api\" slot=\"${JSF_MODULE}\"><dependencies><module name=\"javax.enterprise.api\" export=\"true\"/><module name=\"javax.servlet.api\" export=\"true\"/><module name=\"javax.servlet.jsp.api\" export=\"true\"/><module name=\"javax.servlet.jstl.api\" export=\"true\"/><module name=\"javax.validation.api\" export=\"true\"/><module name=\"org.glassfish.javax.el\" export=\"true\"/><module name=\"javax.api\"/></dependencies><resources><resource-root path=\"myfaces-api-${JSF_VERSION}.jar\"/></resources></module>"
MYFACES_INJECTION_MODULE="<?xml version=\"1.0\" encoding=\"UTF-8\"?> <module xmlns=\"urn:jboss:module:1.1\" name=\"org.jboss.as.jsf-injection\" slot=\"${JSF_MODULE}\"> <properties> <property name=\"jboss.api\" value=\"private\"/> </properties> <resources> <resource-root path=\"wildfly-jsf-injection-${WILDFLY_JSF_INJECTION_VERSION}.jar\"/> <resource-root path=\"weld-core-jsf-${WELD_CORE_VERSION}.jar\"/> </resources> <dependencies> <module name=\"com.sun.jsf-impl\" slot=\"${JSF_MODULE}\"/> <module name=\"javax.api\"/> <module name=\"org.jboss.as.web-common\"/> <module name=\"javax.servlet.api\"/> <module name=\"org.jboss.as.ee\"/> <module name=\"javax.enterprise.api\"/> <module name=\"org.jboss.logging\"/> <module name=\"org.jboss.weld.core\"/> <module name=\"org.wildfly.security.elytron\"/> <module name=\"javax.faces.api\" slot=\"${JSF_MODULE}\"/> </dependencies> </module> "

COMMONS_DIGESTER_VERSION="3.2"
COMMONS_DIGESTER_INSTALL_PATH="${EAP_HOME}/modules/org/apache/commons/digester/main/"
COMMONS_DIGESTER_JAR_URL="http://central.maven.org/maven2/org/apache/commons/commons-digester3/${COMMONS_DIGESTER_VERSION}/commons-digester3-${COMMONS_DIGESTER_VERSION}.jar"
COMMONS_DIGESTER_MODULE="<?xml version=\"1.0\" encoding=\"UTF-8\"?> <module xmlns=\"urn:jboss:module:1.1\" name=\"org.apache.commons.digester\"> <properties> <property name=\"jboss.api\" value=\"private\"/> </properties> <resources> <resource-root path=\"commons-digester-${COMMONS_DIGESTER_VERSION}.jar\"/> </resources> <dependencies> <module name=\"javax.api\"/> <module name=\"org.apache.commons.collections\"/> <module name=\"org.apache.commons.logging\"/> <module name=\"org.apache.commons.beanutils\"/> </dependencies> </module>"

installModule() {
    API_JAR_URL=$MOJARRA_API_JAR_URL
    API_MODULE=$MOJARRA_API_MODULE
    IMPL_JAR_URL=$MOJARRA_IMPL_JAR_URL
    IMPL_MODULE=$MOJARRA_IMPL_MODULE
    INJECTION_MODULE=${MOJARRA_INJECTION_MODULE}
    
    if [ "$JSF_NAME" == "myfaces" ]; then
        API_JAR_URL=$MYFACES_API_JAR_URL
        API_MODULE=$MYFACES_API_MODULE
        IMPL_JAR_URL=$MYFACES_IMPL_JAR_URL
        IMPL_MODULE=$MYFACES_IMPL_MODULE
        INJECTION_MODULE=$MYFACES_INJECTION_MODULE
    fi

    wget --quiet -U "Dummy User Agent" $API_JAR_URL
    wget --quiet -U "Dummy User Agent" $IMPL_JAR_URL

    API_JAR_NAME=$(basename ${API_JAR_URL})
    IMPL_JAR_NAME=$(basename ${IMPL_JAR_URL})

    mkdir -p ${API_INSTALL_PATH}
    cp $API_JAR_NAME "${API_INSTALL_PATH}/${API_JAR_NAME}"
    mkdir -p ${IMPL_INSTALL_PATH}
    cp $IMPL_JAR_NAME "${IMPL_INSTALL_PATH}/${IMPL_JAR_NAME}"

    echo $API_MODULE > "${API_INSTALL_PATH}/module.xml"
    echo $IMPL_MODULE > "${IMPL_INSTALL_PATH}/module.xml"
   
    mkdir -p ${INJECTION_TARGET_PATH}
    cp ${INJECTION_SOURCE_PATH}/*.jar ${INJECTION_TARGET_PATH}
    echo $INJECTION_MODULE > "${INJECTION_TARGET_PATH}/module.xml" 

    if [ "$JSF_NAME" == "myfaces" ]; then
        wget -U "Dummy User Agent" $COMMONS_DIGESTER_JAR_URL
        CD_JAR_NAME=$(basename ${COMMONS_DIGESTER_JAR_URL})
        mkdir -p ${COMMONS_DIGESTER_INSTALL_PATH}
        cp ${CD_JAR_NAME} "${COMMONS_DIGESTER_INSTALL_PATH}/${CD_JAR_NAME}"
        echo ${COMMONS_DIGESTER_MODULE} > "${COMMONS_DIGESTER_INSTALL_PATH}/module.xml"
    fi
}

installModule
