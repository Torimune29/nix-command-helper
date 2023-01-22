from yaml import load
from yaml import CLoader as Loader

y = load(
    stream="""
    - test: success
""",
    Loader=Loader,
)
print(y[0]["test"])
