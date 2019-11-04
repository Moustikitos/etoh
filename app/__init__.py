# -*- encoding:utf-8 -*-
import os
import flask


# create the application instance 
app = flask.Flask(__name__)
app.config.update(
	# 300 seconds = 5 minutes lifetime session
	PERMANENT_SESSION_LIFETIME = 300,
	# used to encrypt cookies
	# secret key is generated each time app is restarted
	SECRET_KEY = os.urandom(24),
	# JS can't access cookies
	SESSION_COOKIE_HTTPONLY = True,
	# bi use of https
	SESSION_COOKIE_SECURE = False,
	# update cookies on each request
	# cookie are outdated after PERMANENT_SESSION_LIFETIME seconds of idle
	SESSION_REFRESH_EACH_REQUEST = True,
	# 
	TEMPLATES_AUTO_RELOAD = True
)

########################
# css reload bugfix... #
########################
def dated_url_for(endpoint, **values):
	if endpoint == 'static':
		filename = values.get("filename", False)
		if filename:
			file_path = os.path.join(app.root_path, endpoint, filename)
			try:
				values["q"] = int(os.stat(file_path).st_mtime)
			except OSError:
				pass
	return flask.url_for(endpoint, **values)
########################


@app.route("/")
def index():
	return flask.render_template("index.html")


if __name__ == "__main__":
	app.run("http://127.0.0.1", port=5001)
