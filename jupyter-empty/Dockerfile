FROM jupyter/scipy-notebook:lab-4.0.7

# Update JupyterLab, remove the empty work directory
RUN pip install jupyterlab==4.1.4 && \
    rm -rf /home/jovyan/work && \
    pip install jupyterlab-git==0.50.0 && \
    pip install pexpect==4.9.0  && 

CMD ["start-notebook.py"]
