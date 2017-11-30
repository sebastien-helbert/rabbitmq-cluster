FROM rabbitmq:3.6.14-management
MAINTAINER Sébastien HELBERT sebastien.helbert@netapsys.fr

RUN rabbitmq-plugins enable rabbitmq_management --offline
RUN rabbitmq-plugins enable rabbitmq_management_agent --offline
RUN rabbitmq-plugins enable rabbitmq_shovel --offline 
RUN rabbitmq-plugins enable rabbitmq_shovel_management --offline

COPY rabbit-cluster-init.sh /opt/rabbit/rabbit-cluster-init.sh
RUN chmod +x /opt/rabbit/rabbit-cluster-init.sh
RUN chown rabbitmq:rabbitmq /opt/rabbit/rabbit-cluster-init.sh
USER rabbitmq

CMD /opt/rabbit/rabbit-cluster-init.sh
