package ${YYAndroidPackageName};

import ${YYAndroidPackageName}.R;

import android.net.Uri;

import java.util.ArrayList;

public class IOStream {
    private int openedTextFiles = 0;
    private int openedBinaryFiles = 0;

    private final ArrayList<IOStreamText> textFiles = new ArrayList<>();
    private final ArrayList<IOStreamBinary> binaryFiles = new ArrayList<>();

    // Text
    public double file_text_open(Uri uri, String mode) {
        double result = -1;
        boolean already = false;

        int size = textFiles.size();
        IOStreamText ios;
        for (int i = 0; i < size; i++) {
            ios = textFiles.get(i);
            if (ios.getUri() != null && ios.getUri().toString().equals(uri.toString())) {
                already = true;
                break;
            }
        }

        if (!already) {
            textFiles.add(new IOStreamText(uri, mode));
            result = textFiles.size() - 1;
            openedTextFiles += 1;
        }

        return result;
    }

    public double file_text_read_real(double _index) {
        int index = (int) _index;
        return textFiles.get(index).readReal();
    }

    public String file_text_read_string(double _index) {
        int index = (int) _index;
        return textFiles.get(index).readString();
    }

    public String file_text_readln(double _index) {
        int index = (int) _index;
        return textFiles.get(index).readln();
    }

    public void file_text_write_real(double _index, double _value) {
        int index = (int) _index;
        textFiles.get(index).write(_value);
    }

    public void file_text_write_string(double _index, String _value) {
        int index = (int) _index;
        textFiles.get(index).write(_value);
    }

    public void file_text_writeln(double _index, String _value) {
        int index = (int) _index;
        textFiles.get(index).writeln(_value);
    }

    public double file_text_eoln(double _index) {
        int index = (int) _index;
        return textFiles.get(index).eoln();
    }

    public double file_text_eof(double _index) {
        int index = (int) _index;
        return textFiles.get(index).eof();
    }

    public void file_text_close(double _index) {
        int index = (int) _index;
        textFiles.get(index).close();
        textFiles.set(index, null);

        openedTextFiles -= 1;
        if (openedTextFiles == 0) {
            textFiles.clear();
        }
    }

    // Binary
    public double file_binary_open(Uri uri, String mode) {
        double result = -1;
        boolean already = false;

        int size = binaryFiles.size();
        IOStreamBinary ios;
        for (int i = 0; i < size; i++) {
            ios = binaryFiles.get(i);
            if (ios.getUri() != null && ios.getUri().toString().equals(uri.toString())) {
                already = true;
                break;
            }
        }

        if (!already) {
            binaryFiles.add(new IOStreamBinary(uri, mode));
            result = binaryFiles.size() - 1;
            openedBinaryFiles += 1;
        }

        return result;
    }

    public void file_binary_rewrite(double _index) {
        int index = (int) _index;
        binaryFiles.get(index).rewrite();
    }

    public void file_binary_write_byte(double _index, double _value) {
        int index = (int) _index;
        binaryFiles.get(index).write(_value);
    }

    public double file_binary_read_byte(double _index) {
        int index = (int) _index;
        return binaryFiles.get(index).read();
    }

    public void file_binary_close(double _index) {
        int index = (int) _index;
        binaryFiles.get(index).close();
        binaryFiles.set(index, null);

        openedBinaryFiles -= 1;
        if (openedBinaryFiles == 0) {
            binaryFiles.clear();
        }
    }
}