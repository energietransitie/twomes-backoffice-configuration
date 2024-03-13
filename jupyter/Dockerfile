# Use 3.6.3, as 3.7.0 has issues with jupyterlab-git.
# https://github.com/jupyterlab/jupyterlab-git/issues/1245#issuecomment-1587729038.
FROM jupyter/scipy-notebook:lab-3.6.3

# Remove the empty work directory.
# Clone the repository and install requirements
# RUN rm -rf /home/jovyan/work && \
RUN git clone https://github.com/energietransitie/needforheat-analysis.git && \
    cd needforheat-analysis && \
    pip install -r requirements.txt

# Setup jupyterlab-git extension and enable it
RUN pip install --upgrade jupyterlab-git && \
    jupyter labextension install @jupyterlab/git && \
    jupyter serverextension enable --py jupyterlab_git

CMD ["start-notebook.sh"]
