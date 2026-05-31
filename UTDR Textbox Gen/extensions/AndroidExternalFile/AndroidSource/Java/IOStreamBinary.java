package ${YYAndroidPackageName};

import ${YYAndroidPackageName}.R;

import android.app.Activity;
import android.content.ContentResolver;
import android.net.Uri;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

public class IOStreamBinary {
    private Activity activity = RunnerActivity.CurrentActivity;
    private ContentResolver resolver = activity.getContentResolver();

    private String mode; //"r", "w", "a"
    private Uri uri;

    private BufferedInputStream inputs = null;
    private BufferedOutputStream outputs = null;

    public IOStreamBinary(Uri _uri, String _mode) {
        uri = _uri;
        mode = _mode.toLowerCase().trim();

        switch (mode) {
            default:
                break;
            case "r":
                try {
                    inputs = new BufferedInputStream(resolver.openInputStream(uri));
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;
            case "w":
                try {
                    outputs = new BufferedOutputStream(resolver.openOutputStream(uri, "w"));
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;
            case "a":
                try {
                    outputs = new BufferedOutputStream(resolver.openOutputStream(uri, "wa"));
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;
        }
    }

    public Uri getUri() {
        return uri;
    }

    public String getMode() {
        return mode;
    }

    // BINARY MODE
    public void rewrite() {
        if (mode.equals("w") || mode.equals("a")) {
            try {
                outputs.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

            try {
                outputs = new BufferedOutputStream(resolver.openOutputStream(uri, "w"));
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }
        }
    }

    public double read() {
        int result = -1;

        try {
            result = inputs.read();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return result;
    }

    public void write(double _byte) {
        try {
            outputs.write((byte) _byte);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void close() {
        try {
            if (inputs != null) {
                inputs.close();
            }
            if (outputs != null) {
                outputs.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        uri = null;
    }
}