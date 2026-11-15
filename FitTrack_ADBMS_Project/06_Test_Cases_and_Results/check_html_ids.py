import re
from bs4 import BeautifulSoup

with open('FitTrack_ADBMS_Project/05_Web_Application/templates/index.html', 'r', encoding='utf-8') as f:
    content = f.read()

soup = BeautifulSoup(content, 'html.parser')

nav_buttons = [b.get('onclick') for b in soup.find_all('button', class_='nav-link')]
print('Nav button onclicks:', nav_buttons)

sections = [s.get('id') for s in soup.find_all('section')]
print('Section IDs in HTML:', sections)

ids_in_script = set(re.findall(r"document\.getElementById\(['\"](.*?)['\"]\)", content))
ids_in_html = set([tag.get('id') for tag in soup.find_all(id=True)])

missing = ids_in_script - ids_in_html
print('IDs in JS but missing in HTML:', missing)
