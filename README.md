---
Projeto: terraform-libvirt-debian
Descrição: Esse projeto tem o objetivo de provisionar uma Máquina Virtual (VM) com o provider
           libvirt (KVM) e o Sistema Operacional GNU/Linux Debian.
Autor: Glauber GF (mcnd2)
Atualização: 2022-06-20
---

# Provisionar uma Máquina Virtual com o libvirt (KVM)

![Image](https://github.com/glaubergf/terraform-libvirt-debian/blob/main/pictures/vm.jpg)

## O projeto [**libvirt**](https://libvirt.org/)

* é um kit de ferramentas para gerenciar plataformas de virtualização;
* é acessível a partir de linguagem de programação como C, Python, Perl, Go e muito mais
* está licenciado sob licenças de código aberto [GPL](https://en.wikipedia.org/wiki/GNU_Lesser_General_Public_License);
* suporta KVM, Hypervisor.framework, QEMU, Xen, Virtuozzo, VMWare ESX, LXC, BHyve e mais;
* tem como alvo Linux, FreeBSD, Windows e macOS;
* é usado por muitas aplicações.

## Provisionando com o [**Terraform**](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs)

Nesse parte vou explicar alguns aspectos sobre o projeto.

Temos 6 arquivos fundamentais para o projeto que são:

* **provider.tf** - O provider Libvirt é usado para interagir com hipervisors libvirt do Linux.
O provedor precisa ser configurado com as informações de conexão adequadas antes de poder ser usado.

* **libvirt.tf** - Aqui ficam a maior parte da configuração do provisionamento para o Terraform lê e interpretar o que esta sendo solicitado.

Dentro de cada bloco temos as configurações com o objetivo de:

      Gerenciar um volume de armazenamento em libvirt;
      Gerenciar um pool de armazenamento em libvirt (*atualmente, apenas o conjunto de armazenamento baseado em diretório é suportado*);
      Gerenciar um recurso de rede VM no libvirt;
      Gerenciar um recurso de domínio VM dentro da libvirt; e
      Gerenciar um disco ISO [**cloud-init**](https://cloudinit.readthedocs.io/en/latest/index.html) que pode ser usado para personalizar um domínio durante a primeira inicialização.

* **variable.tf** - A linguagem Terraform inclui alguns tipos de blocos para solicitar ou publicar valores nomeados.
Um valor local atribui um nome a uma expressão, para que se possa usar o nome várias vezes em um módulo em vez de repetir a expressão.

* **output.tf** - Os valores de saída disponibilizam informações sobre a infraestrutura na linha de comando e podem expor informações para outras configurações do Terraform usarem.

* **config/network_config.yml** - Esse formato de configuração de rede permite que os usuários personalizem as interfaces de rede de suas instâncias atribuindo configurações de sub-rede, rotas de criação de dispositivos virtuais (bonds, bridges, vlans) e configuração de DNS.

* **config/cloud_init.yml** - Com o **cloud-config** é a maneira mais simples de realizar algumas coisas por meio de dados do usuário. Usando a sintaxe cloud-config, o usuário pode especificar certas coisas em um formato amigável.

Essas coisas incluem:

      apt upgrade deve ser executado na primeira inicialização;
      um espelho apt diferente deve ser usado;
      fontes apt adicionais devem ser adicionadas;
      certas chaves SSH devem ser importadas;
      e muitos mais…

## Aplicando o projeto

Para aplicar o projeto, basta executar os comandos *terraform* a seguir:

* **init** - *Preparar o diretório de trabalho para outros comandos.*

```
terraform init
```

* **plan** - *Mostrar as alterações exigidas pela configuração atual.*

```
terraform plan
```

* **apply** - *Criar ou atualizar infraestrutura.*

```
terraform apply
```

* **destroy** - *Destruir a infraestrutura criada anteriormente.*

```
terraform destroy
```

Caso queira executar os comandos *apply* e *destroy* sem digitar **yes** para a confirmação, acrescente nos comandos o parâmetro **--auto-approve**, assim após executar o comando será executado sem pedir a interação da confirmação, não tem volta, rs!

* **--auto-approve** - *Ignorar a aprovação interativa do plano antes de aplicar.*

```
terraform apply --auto-approve
terraform destroy --auto-approve
```

## Licença

**GNU General Public License** (_Licença Pública Geral GNU_), **GNU GPL** ou simplesmente **GPL**.

[GPLv3](https://www.gnu.org/licenses/gpl-3.0.html)

------

Copyright (c) 2022 Glauber GF (mcnd2)

Este programa é um software livre: você pode redistribuí-lo e/ou modificar
sob os termos da GNU General Public License conforme publicada por
a Free Software Foundation, seja a versão 3 da Licença, ou
(à sua escolha) qualquer versão posterior.

Este programa é distribuído na esperança de ser útil,
mas SEM QUALQUER GARANTIA; sem mesmo a garantia implícita de
COMERCIALIZAÇÃO ou ADEQUAÇÃO A UM DETERMINADO FIM. Veja o
GNU General Public License para mais detalhes.

Você deve ter recebido uma cópia da Licença Pública Geral GNU
junto com este programa. Caso contrário, consulte <https://www.gnu.org/licenses/>.

*

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>
