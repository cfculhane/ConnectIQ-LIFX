import json
from pathlib import Path

import requests

SCENE_SET = ""

token = Path(r"ConnectIQ-LIFX.token").read_text().strip()

headers = {
    "Authorization": f"Bearer {token}",
}

lights_req = requests.get('https://api.lifx.com/v1/lights/all', headers=headers)
if lights_req.ok is True:
    lights = json.loads(lights_req.text)

scenes_req = requests.get('https://api.lifx.com/v1/scenes', headers=headers)
if scenes_req.ok is True:
    scenes = json.loads(scenes_req.text)
    print(f"Available Scenes: ")
    print(f"NAME | UUID ")
    print("\n".join([f"{scene['name']} | {scene['uuid']}" for scene in scenes]))
else:
    raise requests.HTTPError("Could not get Scenes")

SCENE_UUID = scenes[1]["uuid"]

# apply_scene_req = requests.put(f"https://api.lifx.com/v1/scenes/scene_id:{SCENE_UUID}/activate", headers=headers)
#
# power_toggle_rq = requests.post('https://api.lifx.com/v1/lights/all/toggle', headers=headers)
#
