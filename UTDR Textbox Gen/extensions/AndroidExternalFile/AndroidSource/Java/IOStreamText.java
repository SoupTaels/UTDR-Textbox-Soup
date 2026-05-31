package ${YYAndroidPackageName};

import ${YYAndroidPackageName}.R;

import android.app.Activity;
import android.content.ContentResolver;
import android.net.Uri;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Scanner;

public class IOStreamText {

    private String mode; //"r", "w", "a"
    private Uri uri;

    private BufferedInputStream inputs = null;
    private BufferedOutputStream outputs = null;
    private Scanner scanner = null;
    private PrintWriter writer = null;

    public IOStreamText(Uri _uri, String _mode) {
        uri = _uri;
        mode = _mode.toLowerCase().trim();

        Activity activity = RunnerActivity.CurrentActivity;
        ContentResolver resolver = activity.getContentResolver();
        switch (mode) {
            default:
                break;
            case "r":
                try {
                    inputs = new BufferedInputStream(resolver.openInputStream(uri));
                    scanner = new Scanner(inputs);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;
            case "w":
                try {
                    outputs = new BufferedOutputStream(resolver.openOutputStream(uri, "w"));
                    writer = new PrintWriter(outputs);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;
            case "a":
                try {
                    outputs = new BufferedOutputStream(resolver.openOutputStream(uri, "wa"));
                    writer = new PrintWriter(outputs);
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

    // TEXT MOD
    public double readReal() {
        double result = Double.parseDouble(null);

        if (scanner.hasNext()) {
            result = scanner.nextDouble();
        }

        return result;
    }

    public String readString() {
        String result = null;

        if (scanner.hasNext()) {
            result = scanner.next();
        }

        return result;
    }

    public String readln() {
        String result = null;

        if (scanner.hasNextLine()) {
            result = scanner.nextLine();
        }

        return result;
    }

    public void write(double _real) {
        writer.print(_real);
    }

    public void write(String _string) {
        writer.print(_string);
    }

    public void writeln(String _string) {
        writer.println(_string);
    }

    public double eoln() {
        double result = 0;
        if (scanner.hasNextLine()) {
            result = 1;
        }

        return result;
    }

    public double eof() {
        double result = 0;
        if (scanner.hasNext()) {
            result = 1;
        }

        return result;
    }

    public void close() {
        if (scanner != null) {
            scanner.close();
        }
        if (writer != null) {
            writer.close();
        }

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