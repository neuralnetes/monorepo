import asyncio
import json

import click
from kubernetes import client, config


async def run(cmd):
    proc = await asyncio.create_subprocess_shell(
        cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )

    stdout, stderr = await proc.communicate()
    result = proc.returncode, stdout, stderr
    print(result)
    return result


async def gather_all(f, xs):
    return await asyncio.gather(*[f(x) for x in xs])


async def flux_reconcile(name):
    return await run(f'flux reconcile kustomization {name}')


def get_flux_kustomization_sha(item):
    return item['status']['conditions'][0]['message'].split("/")[-1]


def get_flux_kustomization_name(item):
    return item['metadata']['name']


async def handle_flux_reconcile(args):
    github_sha = args['github_sha']
    custom = client.CustomObjectsApi()
    (response, _, _) = custom.list_namespaced_custom_object_with_http_info(group="kustomize.toolkit.fluxcd.io",
                                                                           version="v1beta1",
                                                                           plural="kustomizations",
                                                                           namespace="flux-system")
    names = [
        get_flux_kustomization_name(item)
        for item in response['items']
        if get_flux_kustomization_sha(item) != github_sha
    ]
    return await gather_all(flux_reconcile, names)


@click.command()
@click.option('--command', default="", help='command')
@click.option('--args', default="", help='args')
def entry(command, args):
    args = json.loads(args)
    config.load_kube_config()

    if command == "flux_reconcile":
        asyncio.run(handle_flux_reconcile(args))


if __name__ == '__main__':
    entry()
