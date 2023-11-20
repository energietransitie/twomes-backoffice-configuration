# Use 3.6.3, as 3.7.0 has issues with jupyterlab-git.
# https://github.com/jupyterlab/jupyterlab-git/issues/1245#issuecomment-1587729038.
FROM jupyter/scipy-notebook:lab-3.6.3

# Setup jupyterlab-git extension
RUN pip install --upgrade jupyterlab-git

# Remove the empty work directory.
RUN rm -rf /home/jovyan/work

CMD ["start-notebook.sh"]
