FROM jupyter/scipy-notebook:lab-4.1.4

# Remove the empty work directory, clone the repository and install requirements
RUN rm -rf /home/jovyan/work && \
    git clone https://github.com/energietransitie/needforheat-analysis.git && \
    cd needforheat-analysis && \
    pip install jupyterlab-git==0.50.0 && \
    pip install -r requirements.txt

# Setup jupyterlab-git extension and enable it
# RUN jupyter labextension install @jupyterlab/git && \
#    jupyter labextension enable @jupyterlab/git

CMD ["start-notebook.sh"]
