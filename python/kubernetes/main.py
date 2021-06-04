import asyncio

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


async def flux_reconcile(kustomization_name):
    return await run(f'flux reconcile kustomization {kustomization_name}')


async def flux_reconcile_all(flux_kustomization_names):
    return await asyncio.gather(*[flux_reconcile(name) for name in flux_kustomization_names])


@click.command()
@click.option('--command', default="", help='command')
@click.option('--args', default="", help='args')
def entry(command, args):
    config.load_kube_config()

    if command == "flux_reconcile":
        custom = client.CustomObjectsApi()
        (response, _, _) = custom.list_namespaced_custom_object_with_http_info(group="kustomize.toolkit.fluxcd.io",
                                                                               version="v1beta1",
                                                                               plural="kustomizations",
                                                                               namespace="flux-system")
        kustomization_names = [item['metadata']['name'] for item in response['items']]
        asyncio.run(flux_reconcile_all(kustomization_names))


if __name__ == '__main__':
    entry()
