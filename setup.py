from setuptools import setup


setup(
        name="wokefuzz",
        version="0.0.1",
        python_requires=">=3.7, <4",
        install_requires=[
            'woke==3.5.0',
            'pyright==1.1.320',
            'jsons==1.6.3'
        ]
)
