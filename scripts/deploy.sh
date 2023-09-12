# git clone
echo "start to clone"
git clone https://github.com/bainaryho/DRF_SNS.git tee2
cd tee2

# venv 설치
echo "start to install venv"
sudo apt-get update && sudo apt install -y python3.8-venv

# venv 구성
echo "start to make venv"
python3 -m venv venv

# 가상환경 작동
echo "start to activate venv"
source venv/bin/activate

# pip install
echo "start to install requirements"
pip install python-dotenv
pip install -r requirements.txt