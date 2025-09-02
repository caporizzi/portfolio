import uuid
from flask import Blueprint, request
from deepface import DeepFace
from deepface.api.src.modules.core import service
from deepface.commons.logger import Logger
import os
import base64

logger = Logger()

blueprint = Blueprint("routes", __name__)

def _write_base64_image(image_data, target_file):
    decoded = base64.b64decode(image_data)
    with open(target_file, "wb") as f:
        f.write(decoded)

@blueprint.route("/upload_pic", methods=["POST"])
def upload_pics():
    target_dir = "./pics"

    print("upload_pics: ", target_dir)

    # create directory if not exists
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)

    input_args = request.get_json()
    
    image_data = input_args.get("image_data")
    userid = input_args.get("user_id")

    if image_data is None:
        logger.error("No image_data in request")
        return {"result": "error", "error": "No image_data in request"}, 400

    if userid is None:
        logger.error("No userid in request")
        return {"result": "error", "error": "No userid in request"}, 400

    # write the image to our directory
    _write_base64_image(image_data, f"{target_dir}/{userid}.jpg")

    return {"result": "ok"}, 200

    
@blueprint.route("/find", methods=["POST"])
def find():
    target_dir = "./temp_pics"

    logger.info("find")

    # create directory if not exists
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)

    input_args = request.get_json()

    image_data = input_args.get("image_data")

    if image_data is None:
        logger.error("No image_data in request")
        return {"result": "error", "error": "No image_data in request"}, 400

    # temporarily write the image to disk
    temp_id = str(uuid.uuid4())
    target_file = f"{target_dir}/{temp_id}.jpg"
    _write_base64_image(image_data, target_file)
    
    # find the face's identity
    res = DeepFace.find(
        img_path=target_file,
        db_path="./pics",
    )

    # delete temp file
    os.remove(target_file)

    try:
        # get the user_id from the file path
        file_path = res[0]["identity"][0]
        user_id = os.path.basename(file_path).split(".")[0]

        print("\tuser_id: ", user_id)

        return { "result": "ok", "user_id": user_id }, 200
    except:
        print("\tNo match found")
        return { "result": "No match found" }, 200
        

@blueprint.route("/count_faces", methods=["POST"])
def count_faces():
    target_dir = "./temp_pics"

    logger.info("count_faces")

    # create directory if not exists
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)

    input_args = request.get_json()

    image_data = input_args.get("image_data")

    if image_data is None:
        logger.error("No image_data in request")
        return {"result": "error", "error": "No image_data in request"}, 400
    
    # temporarily write the image to disk
    temp_id = str(uuid.uuid4())
    target_file = f"{target_dir}/{temp_id}.jpg"
    _write_base64_image(image_data, target_file)

    # count the number of faces in the image
    faces_count = 0
    try:
        faces_count = len(DeepFace.extract_faces(
            img_path=target_file,
            normalize_face=True,
        ))
    except:
        faces_count = 0

    print("\tfaces_count: ", faces_count)

    # delete temp file
    os.remove(target_file)

    return { "result": "ok", "count": faces_count }, 200