import os
import random
from shutil import move

def split_dataset(image_dir, label_dir, train_ratio=0.8):
    """
    将图像和标签文件随机划分为训练集和验证集。
    如果标签文件不存在，则创建一个空的标签文件。

    Args:
        image_dir (str): 包含所有图像的目录。
        label_dir (str): 包含所有标签的目录。
        train_ratio (float): 训练集所占的比例 (0.0 到 1.0)。
    """
    image_files = [f for f in os.listdir(image_dir) if f.endswith(('.jpg', '.jpeg', '.png'))]
    random.shuffle(image_files)
    split_index = int(len(image_files) * train_ratio)

    train_images = image_files[:split_index]
    val_images = image_files[split_index:]

    # 创建训练集和验证集目录（如果不存在）
    os.makedirs(os.path.join(image_dir, 'train'), exist_ok=True)
    os.makedirs(os.path.join(image_dir, 'val'), exist_ok=True)
    os.makedirs(os.path.join(label_dir, 'train'), exist_ok=True)
    os.makedirs(os.path.join(label_dir, 'val'), exist_ok=True)

    for img_file in train_images:
        base_name = os.path.splitext(img_file)[0]
        label_file = base_name + '.txt'
        src_img_path = os.path.join(image_dir, img_file)
        dst_img_path = os.path.join(image_dir, 'train', img_file)
        src_label_path = os.path.join(label_dir, label_file)
        dst_label_path = os.path.join(label_dir, 'train', label_file)

        move(src_img_path, dst_img_path)
        if os.path.exists(src_label_path):
            move(src_label_path, dst_label_path)
        else:
            # 创建一个空的标签文件
            with open(dst_label_path, 'w') as f:
                pass
            print(f"信息: 为训练集图像 {img_file} 创建了空的标签文件。")

    for img_file in val_images:
        base_name = os.path.splitext(img_file)[0]
        label_file = base_name + '.txt'
        src_img_path = os.path.join(image_dir, img_file)
        dst_img_path = os.path.join(image_dir, 'val', img_file)
        src_label_path = os.path.join(label_dir, label_file)
        dst_label_path = os.path.join(label_dir, 'val', label_file)

        move(src_img_path, dst_img_path)
        if os.path.exists(src_label_path):
            move(src_label_path, dst_label_path)
        else:
            # 创建一个空的标签文件
            with open(dst_label_path, 'w') as f:
                pass
            print(f"信息: 为验证集图像 {img_file} 创建了空的标签文件。")

if __name__ == "__main__":
    # 将这里的路径替换为你的实际图像和标签目录
    image_directory = 'dataset/images'
    label_directory = 'dataset/labels'
    train_proportion = 0.8  # 80% 用于训练，20% 用于验证

    split_dataset(image_directory, label_directory, train_proportion)
    print("数据集划分完成！")