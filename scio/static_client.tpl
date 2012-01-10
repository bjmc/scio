#
# WARNING: this module is autogenerated. Do not edit this file!
#
from scio import client, static

#
# Client class
#
class Client(static.Client):
    _types = static.TypeRegistry()

    class _service(object):
        def __init__(self, client_):
            self._client = client_
{% for meth in methods %}
        @property
        def {{ meth.name }}(self):
            client_ = self._client
            meth = client_.methodClass(
                '{{ meth.location }}',
                '{{ meth.name }}',
                '{{ meth.action }}',
                client_.inputClass('{{ meth.input.tag }}',
                                   '{{ meth.input.namespace }}',
                                   [{% for part in meth.input.parts -%}
                                    ('{{ part.0 }}', {{ part.1 }}),
                                    {% endfor %}],
                                   '{{ meth.input.style }}',
                                   '{{ meth.input.literal }}',
                                   [{% for part in meth.input.headers -%}
                                    ('{{ part.0 }}', {{ part.1 }}),
                                    {% endfor %}]),
                client_.outputClass('{{ meth.output.tag }}',
                                    '{{ meth.output.namespace }}',
                                    [{% for part in meth.output.parts -%}
                                     ('{{ part.0 }}', {{ part.1 }}),
                                     {% endfor %}],
                                    [{% for part in meth.output.headers -%}
                                     ('{{ part.0 }}', {{ part.1 }}),
                                     {% endfor %}])
                )
            return client_.methodCallClass(client_, meth)
{% endfor %}

#
# Types
#
{% for tp in types %}
@Client.register
class {{ tp.class_name }}({{ tp.bases|join(', ') }}):
    _name = '{{ tp.name }}'
    {%- for name, val in tp.fields %}
    {{ name }} = {{ val }}
    {%- endfor %}
    {%- if tp.schema and tp.schema.nsmap %}
    _schema = static.Schema(
        {{ tp.schema.nsmap }},
        '{{ tp.schema.targetNamespace }}',
        {{ tp.schema.qualified }})
    {%- endif %}

{% endfor %}
Client.resolve_refs()
