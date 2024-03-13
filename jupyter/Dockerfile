FROM jupyter/scipy-notebook:lab-4.0.7

# Update JupyterLab, remove the empty work directory, clone the repository and install requirements
RUN pip install jupyterlab==4.1.4 && \
    rm -rf /home/jovyan/work && \
    pip install jupyterlab-git==0.50.0 && \
    git clone https://github.com/energietransitie/needforheat-analysis.git && \
    cd needforheat-analysis && \
    pip install -r requirements.txt

# Setup jupyterlab-git extension and enable it
# RUN jupyter labextension install @jupyterlab/git && \
#    jupyter labextension enable @jupyterlab/git

CMD ["start-notebook.sh"]
