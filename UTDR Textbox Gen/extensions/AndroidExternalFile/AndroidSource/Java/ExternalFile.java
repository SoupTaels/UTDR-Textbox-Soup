package ${YYAndroidPackageName};

import ${YYAndroidPackageName}.R;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.provider.DocumentsContract;
import android.provider.Settings;
import android.widget.Toast;

import androidx.documentfile.provider.DocumentFile;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.yoyogames.runner.RunnerJNILib;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class ExternalFile extends RunnerSocial {

    private static final int EVENT_ASYNC_SOCIAL = 70;

    private static final int SHOW_SETTINGS = 21;

    private static final int SAF_REQUEST_SEARCH_DIRECTORY = 31;
    private static final int SAF_REQUEST_GET_DIRECTORY = 32;
    private static final int SAF_REQUEST_SEARCH_FILE = 41;
    private static final int SAF_REQUEST_GET_FILE = 42;

    private static final int RESULT_FAIL = 0;
    private static final int RESULT_SUCCESS = 1;
    private static final int RESULT_SUCCESS_WITH_NOTICE = 2;

    private static final String[] MIME_TYPE = {
        "*/*",
        "text/*",
        "image/*",
        "video/*",
        "audio/*",
        "multipart/*",
        "application/*"
    };

    private static final String FILE_BINARY = "application/octet-stream";
    private static final String FILE_TEXT = "text/plain";

    private final Activity activity = RunnerActivity.CurrentActivity;
    private final Context context = activity.getApplicationContext();
    private final ContentResolver resolver = activity.getContentResolver();

    private Uri saf_root = null;
    private Uri saf_init = null;

    private String saf_root_path = "";
    private String saf_init_path = "";

    private final String pref_directory = context.getPackageName() + ".preference";
    private final String[] pref_key = {
        "saf_root",
        "saf_init"
    };
    private final SharedPreferences pref = activity.getSharedPreferences(pref_directory, Context.MODE_PRIVATE);

    //private ArrayList<String> files = new ArrayList<String>();
    private final IOStream ioStream = new IOStream();


    /*  INTENT ACTIVITY  */
    public String intent_saf_request(double _request_code, double _mime_type) {
        int request_code = (int) _request_code;
        int mime_type = (int) _mime_type;

        String preference = "";
        String result = "";

        Intent intent = null;
        int ds_map = -1;

        switch (request_code) {
            case SAF_REQUEST_SEARCH_DIRECTORY:
                intent = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
                activity.startActivityForResult(intent, SAF_REQUEST_SEARCH_DIRECTORY);
                break;
            case SAF_REQUEST_GET_DIRECTORY:
                preference = pref.getString(pref_key[0], "");
                result = preference;

                if (!preference.equalsIgnoreCase("")) {
                    saf_root = Uri.parse(preference);
                    Uri uri = DocumentsContract.buildDocumentUriUsingTree(saf_root, DocumentsContract.getTreeDocumentId(saf_root));

                    saf_root_path = get_path_from_uri(context, uri);

                    ds_map = RunnerJNILib.jCreateDsMap(null, null, null);
                    RunnerJNILib.DsMapAddString(ds_map, "type", "saf_request_get_directory");
                    RunnerJNILib.DsMapAddString(ds_map, "path", saf_root_path);
                    RunnerJNILib.CreateAsynEventWithDSMap(ds_map, EVENT_ASYNC_SOCIAL);
                }
                break;
            case SAF_REQUEST_SEARCH_FILE:
                intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
                intent.setType(MIME_TYPE[mime_type]);
                activity.startActivityForResult(intent, SAF_REQUEST_SEARCH_FILE);
                break;
            case SAF_REQUEST_GET_FILE:
                preference = pref.getString(pref_key[1], "");
                result = preference;

                if (!preference.equalsIgnoreCase("")) {
                    saf_init = Uri.parse(preference);
                    Uri uri = DocumentsContract.buildDocumentUriUsingTree(saf_init, DocumentsContract.getTreeDocumentId(saf_init));

                    saf_init_path = get_path_from_uri(context, uri);

                    ds_map = RunnerJNILib.jCreateDsMap(null, null, null);
                    RunnerJNILib.DsMapAddString(ds_map, "type", "saf_request_get_file");
                    RunnerJNILib.DsMapAddString(ds_map, "path", saf_init_path);
                    RunnerJNILib.CreateAsynEventWithDSMap(ds_map, EVENT_ASYNC_SOCIAL);
                }
                break;
            default:
                break;
        }
        return result;
    }

    public void intent_open_setting(String _message) {
        if (!_message.equals("")) {
            final String message = _message;
            Handler handler = new Handler(Looper.getMainLooper());
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    Toast.makeText(context, message, Toast.LENGTH_LONG).show();
                }
            }, 0);
        }

        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:" + context.getPackageName()));
        intent.addCategory(Intent.CATEGORY_DEFAULT);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        activity.startActivityForResult(intent, SHOW_SETTINGS);
    }

    @Override
    public void onActivityResult(int _request_code, int _result_code, Intent _intent) {
        switch (_request_code) {
            case SAF_REQUEST_SEARCH_DIRECTORY:
                if (_result_code == Activity.RESULT_OK) {
                    saf_root = _intent.getData();

                    int flags = _intent.getFlags();
                    flags &= (Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
                    activity.getContentResolver().takePersistableUriPermission(saf_root, flags);

                    Uri uri = DocumentsContract.buildDocumentUriUsingTree(saf_root, DocumentsContract.getTreeDocumentId(saf_root));
                    saf_root_path = get_path_from_uri(context, uri);

                    pref.edit().putString(pref_key[0], saf_root.toString()).apply();

                    int ds_map = RunnerJNILib.jCreateDsMap(null, null, null);
                    RunnerJNILib.DsMapAddString(ds_map, "type", "saf_request_search_directory_accepted");
                    RunnerJNILib.DsMapAddString(ds_map, "path", saf_root_path);
                    RunnerJNILib.CreateAsynEventWithDSMap(ds_map, EVENT_ASYNC_SOCIAL);
                } else if (_result_code == Activity.RESULT_CANCELED) {
                    int ds_map = RunnerJNILib.jCreateDsMap(null, null, null);
                    RunnerJNILib.DsMapAddString(ds_map, "type", "saf_request_search_directory_canceled");
                    RunnerJNILib.CreateAsynEventWithDSMap(ds_map, EVENT_ASYNC_SOCIAL);
                }
                break;
            case SAF_REQUEST_SEARCH_FILE:
                if (_result_code == Activity.RESULT_OK) {
                    saf_init = _intent.getData();

                    int flags = _intent.getFlags();
                    flags &= (Intent.FLAG_GRANT_READ_URI_PERMISSION);
                    activity.getContentResolver().takePersistableUriPermission(saf_init, flags);

                    saf_init_path = get_path_from_uri(context, saf_init);

                    pref.edit().putString(pref_key[1], saf_init.toString()).apply();

                    int ds_map = RunnerJNILib.jCreateDsMap(null, null, null);
                    RunnerJNILib.DsMapAddString(ds_map, "type", "saf_request_search_file_accepted");
                    RunnerJNILib.DsMapAddString(ds_map, "path", saf_init_path);
                    RunnerJNILib.CreateAsynEventWithDSMap(ds_map, EVENT_ASYNC_SOCIAL);
                } else if (_result_code == Activity.RESULT_CANCELED) {
                    int ds_map = RunnerJNILib.jCreateDsMap(null, null, null);
                    RunnerJNILib.DsMapAddString(ds_map, "type", "saf_request_search_file_canceled");
                    RunnerJNILib.CreateAsynEventWithDSMap(ds_map, EVENT_ASYNC_SOCIAL);
                }
                break;
            case SHOW_SETTINGS:
                int ds_map = RunnerJNILib.jCreateDsMap(null, null, null);
                RunnerJNILib.DsMapAddString(ds_map, "type", "permission_checked");
                RunnerJNILib.CreateAsynEventWithDSMap(ds_map, EVENT_ASYNC_SOCIAL);
                break;
            default:
                break;
        }
    }


    /*  FILE PATH SYSTEM  */
    public String directory_get_external_files() {
        String result = "";
        File file = context.getExternalFilesDir(null);

        if (file != null) {
            result = file.getAbsolutePath();
        }

        return result;
    }

    public String directory_get_external_cache() {
        String result = "";
        File file = context.getExternalCacheDir();

        if (file != null) {
            result = file.getAbsolutePath();
        }

        return result;
    }

    public String directory_get_saf_root() {
        return saf_root_path;
    }

    public String directory_get_contents(String _path) {
        String result = "{}";
        File file = new File(_path);

        if (file.isDirectory()) {
            File[] files = file.listFiles();
            Map<String, String> map = new HashMap<>();

            int count_file = 0;
            int count_directory = 0;

            if (files != null) {
                int size = files.length;

                for (File value : files) {
                    if (value.isDirectory()) {
                        map.put("directory_" + count_directory, value.getName());
                        count_directory++;
                    }
                    if (value.isFile()) {
                        map.put("file_" + count_file, value.getName());
                        count_file++;
                    }
                }
            }

            map.put("directory_length", String.valueOf(count_directory));
            map.put("file_length", String.valueOf(count_file));

            Gson gson = new GsonBuilder().disableHtmlEscaping().create();
            result = gson.toJson(map);
        }
        return result;
    }

    public double file_get_size(String _path, String _name) {
        double result = 0;
        File file = new File(_path + "/" + _name);

        if (file.exists())
            result = file.length();

        return result;
    }

    public String file_apply_name(String _path, String _name) {
        String result = "";

        String restrict = "|\\\\?*<\":>/";
        String regex = "[" + restrict + "]+";

        String[] token = _name.split("\\.(?=[^\\.]+$)");
        String name = token[0];
        String ext = token[1];

        int retry = 0;

        name = name.replaceAll(regex, "_");

        File directory = new File(_path);
        if (directory.isDirectory() && directory.exists()) {
            boolean able;
            do {
                result = name + ((retry == 0) ? "" : " (" + retry + ")") + "." + ext;
                File file = new File(_path + "/" + result);
                if (file.exists()) {
                    retry += 1;
                    able = false;
                } else {
                    able = true;
                }
            } while (!able);
        }

        return result;
    }

    /*  SAF PATH SYSTEM  */
    public double saf_directory_create(String _path, String _rename) {
        double result = RESULT_FAIL;
        DocumentFile path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path);

        if (path != null) {
            DocumentFile check = path.findFile(_rename);
            if (check == null) {
                path.createDirectory(_rename);
                result = RESULT_SUCCESS;
            }
        }
        return result;
    }

    public void saf_directory_creates(String _path) {
        DocumentFile home = DocumentFile.fromTreeUri(context, saf_root);
        ArrayList<String> tree = directory_parse(_path);

        DocumentFile path = home;
        for (String p : tree) {
            if (path != null) {
                DocumentFile find = path.findFile(p);
                if (find == null) {
                    path = path.createDirectory(p);
                } else {
                    path = find;
                }
            }
        }
    }

    public double saf_directory_exists(String _path) {
        double result = RESULT_FAIL;
        DocumentFile path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path);

        if (path != null) {
            if (path.exists()) {
                result = RESULT_SUCCESS;
            }
        }
        return result;
    }

    public double saf_directory_rename(String _path, String _name) {
        double result = RESULT_FAIL;
        DocumentFile path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path);

        if (path != null) {
            if (path.renameTo(_name)) {
                result = RESULT_SUCCESS;
            }
        }
        return result;
    }

    public double saf_directory_remove(String _path) {
        double result = RESULT_FAIL;
        DocumentFile path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path);

        if (path != null) {
            if (path.delete()) {
                result = RESULT_SUCCESS;
            }
        }
        return result;
    }

    public String saf_directory_get_contents(String _path) {
        String result = "{}";
        DocumentFile path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path);

        if (path != null) {
            DocumentFile[] contents = path.listFiles();
            Map<String, String> map = new HashMap<>();

            int size = contents.length;

            int count_file = 0;
            int count_directory = 0;
            for (DocumentFile content : contents) {
                if (content.isDirectory()) {
                    map.put("directory_" + count_directory, content.getName());
                    count_directory++;
                }
                if (content.isFile()) {
                    map.put("file_" + count_file, content.getName());
                    count_file++;
                }
            }

            map.put("directory_length", String.valueOf(count_directory));
            map.put("file_length", String.valueOf(count_file));

            Gson gson = new GsonBuilder().disableHtmlEscaping().create();
            result = gson.toJson(map);
        }
        return result;
    }

    public double saf_file_create_text(String _path, String _name) {
        return saf_file_create(_path, _name, FILE_TEXT);
    }

    public double saf_file_create_bin(String _path, String _name) {
        return saf_file_create(_path, _name, FILE_BINARY);
    }

    public double saf_file_create(String _path, String _name, String _mimeType) {
        double result = RESULT_FAIL;
        DocumentFile path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path);

        if (path != null) {
            DocumentFile check = path.findFile(_name);
            if (check == null) {
                DocumentFile file = path.createFile(_mimeType, _name);
                result = RESULT_SUCCESS;
            }
        }
        return result;
    }

    public double saf_file_exists(String _path, String _name) {
        double result = RESULT_FAIL;
        DocumentFile path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path);

        if (path != null) {
            DocumentFile file = path.findFile(_name);
            if (file != null) {
                result = RESULT_SUCCESS;
            }
        }
        return result;
    }

    public double saf_file_rename(String _path, String _name, String _rename) {
        double result = RESULT_FAIL;
        DocumentFile path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path);

        if (path != null) {
            DocumentFile file = path.findFile(_name);
            if (file != null) {
                try {
                    if (DocumentsContract.renameDocument(resolver, file.getUri(), _rename) != null) {
                        result = RESULT_SUCCESS;
                    }
                } catch (FileNotFoundException e) {
                    e.printStackTrace();
                }
            }
        }
        return result;
    }

    public double saf_file_remove(String _path, String _name) {
        double result = RESULT_FAIL;
        DocumentFile path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path);

        if (path != null) {
            DocumentFile file = path.findFile(_name);
            if (file != null) {
                try {
                    if (DocumentsContract.removeDocument(resolver, file.getUri(), path.getUri())) {
                        result = RESULT_SUCCESS;
                    }
                } catch (FileNotFoundException e) {
                    e.printStackTrace();
                }
            }
        }
        return result;
    }

    public double saf_file_move(String _path_src, String _name_src, String _path_dst, String _name_dst) {
        double result = RESULT_FAIL;
        DocumentFile path_src = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path_src);
        DocumentFile path_dst = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path_dst);

        if (path_src != null && path_dst != null) {
            DocumentFile file = path_src.findFile(_name_src);
            if (file != null) {
                try {
                    Uri output = DocumentsContract.moveDocument(resolver, file.getUri(), path_src.getUri(), path_dst.getUri());

                    if (output != null) {
                        if (!_name_dst.equals(""))
                            DocumentsContract.renameDocument(resolver, output, _name_dst);
                        result = RESULT_SUCCESS;
                    }
                } catch (FileNotFoundException e) {
                    e.printStackTrace();
                }
            }
        }
        return result;
    }

    public void saf_file_copy(String _path_src, String _name_src, String _path_dst, String _name_dst) {
        DocumentFile path_src = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path_src);
        DocumentFile path_dst = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path_dst);

        if (path_src != null) {
            DocumentFile file = path_src.findFile(_name_src);
            if (file != null) {
                if (path_dst == null || !path_dst.exists()) {
                    saf_directory_creates(_path_dst);
                    path_dst = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path_dst);
                }
                if (path_dst != null) {
                    DocumentFile output = path_dst.findFile(_name_dst);
                    if (output == null) {
                        output = path_dst.createFile(FILE_BINARY, _name_dst);
                    }
                    if (output != null) {
                        try {
                            InputStream inputStream = resolver.openInputStream(file.getUri());
                            OutputStream outputStream = resolver.openOutputStream(output.getUri());

                            file_copy(inputStream, outputStream);

                            inputStream.close();
                            outputStream.close();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                    /*
                    if (file != null) {
                        try {
                            Uri output = DocumentsContract.copyDocument(resolver, file.getUri(), path_dst.getUri());

                            if (output != null) {
                                if (!_name_dst.equals(""))
                                    DocumentsContract.renameDocument(resolver, output, _name_dst);
                            }
                        } catch (FileNotFoundException e) {
                            e.printStackTrace();
                        }
                    }
                    */
                }
            }
        }
    }

    public void saf_file_copy_from_file(String _path_src, String _name_src, String _path_dst, String _name_dst) throws IOException {
        File input = null;
        if(_name_src.contains(":")) {
            input = new File(_name_src);
        }
        else {
            input = new File(_path_src + "/" + _name_src);
        }

        if (input.exists()) {
            DocumentFile path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path_dst);
            if (path == null || !path.exists()) {
                saf_directory_creates(_path_dst);
                path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path_dst);
            }
            if (path != null) {
                DocumentFile output = path.findFile(_name_dst);
                if (output == null) {
                    output = path.createFile(FILE_BINARY, _name_dst);
                }
                if (output != null) {
                    InputStream inputStream = new FileInputStream(input);
                    OutputStream outputStream = resolver.openOutputStream(output.getUri());

                    file_copy(inputStream, outputStream);

                    inputStream.close();
                    outputStream.close();
                }
            }
        }
    }

    public void saf_file_copy_to_file(String _path_src, String _name_src, String _path_dst, String _name_dst) throws IOException {
        DocumentFile path_src = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path_src);
        if (path_src != null) {
            DocumentFile input = path_src.findFile(_name_src);
            if (input.exists()) {
                File path_dst = new File(_path_dst + "/");
                if (!path_dst.exists()) {
                    path_dst.mkdirs();
                }
                if (path_dst.exists()) {
                    File output = new File(_path_dst + "/" + _name_dst);
                    if (!output.exists()) {
                        output.createNewFile();
                    }
                    if (output.exists()) {
                        InputStream inputStream = resolver.openInputStream(input.getUri());
                        OutputStream outputStream = new FileOutputStream(output);

                        file_copy(inputStream, outputStream);

                        inputStream.close();
                        outputStream.close();
                    }
                }
            }
        }
    }


    /*  SAF IO-STREAM  */
    public double saf_file_text_open_read(String _path, String _name) {
        double result = -1;
        DocumentFile path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path);

        if (path != null) {
            DocumentFile file = path.findFile(_name);
            if (file != null) {
                result = ioStream.file_text_open(file.getUri(), "r");
            }
        }
        return result;
    }

    public double saf_file_text_open_write(String _path, String _name) {
        double result = -1;
        DocumentFile path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path);

        if (path != null) {
            DocumentFile file = path.findFile(_name);
            if (file == null) {
                file = path.createFile(FILE_TEXT, _name);
            }
            if (file != null) {
                result = ioStream.file_text_open(file.getUri(), "w");
            }
        }
        return result;
    }

    public double saf_file_text_open_append(String _path, String _name) {
        double result = -1;
        DocumentFile path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path);

        if (path != null) {
            DocumentFile file = path.findFile(_name);
            if (file == null) {
                file = path.createFile(FILE_TEXT, _name);
            }
            if (file != null) {
                result = ioStream.file_text_open(file.getUri(), "a");
            }
        }
        return result;
    }

    public double saf_file_text_read_real(double _index) {
        return ioStream.file_text_read_real(_index);
    }

    public String saf_file_text_read_string(double _index) {
        return ioStream.file_text_read_string(_index);
    }

    public String saf_file_text_readln(double _index) {
        return ioStream.file_text_readln(_index);
    }

    public void saf_file_text_write_real(double _index, double _value) {
        ioStream.file_text_write_real(_index, _value);
    }

    public void saf_file_text_write_string(double _index, String _value) {
        ioStream.file_text_write_string(_index, _value);
    }

    public void saf_file_text_writeln(double _index, String _value) {
        ioStream.file_text_writeln(_index, _value);
    }

    public double saf_file_text_eoln(double _index) {
        return ioStream.file_text_eoln(_index);
    }

    public double saf_file_text_eof(double _index) {
        return ioStream.file_text_eof(_index);
    }

    public void saf_file_text_close(double _index) {
        ioStream.file_text_close(_index);
    }

    public double saf_file_bin_open_read(String _path, String _name) {
        double result = -1;
        DocumentFile path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path);

        if (path != null) {
            DocumentFile file = path.findFile(_name);
            if (file != null) {
                result = ioStream.file_binary_open(file.getUri(), "r");
            }
        }
        return result;
    }

    public double saf_file_bin_open_write(String _path, String _name) {
        double result = -1;
        DocumentFile path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path);

        if (path != null) {
            DocumentFile file = path.findFile(_name);
            if (file == null) {
                file = path.createFile(FILE_BINARY, _name);
            }
            if (file != null) {
                result = ioStream.file_binary_open(file.getUri(), "w");
            }
        }
        return result;
    }

    public double saf_file_bin_open_append(String _path, String _name) {
        double result = -1;
        DocumentFile path = saf_directory_parse(DocumentFile.fromTreeUri(context, saf_root), _path);

        if (path != null) {
            DocumentFile file = path.findFile(_name);
            if (file == null) {
                file = path.createFile(FILE_BINARY, _name);
            }
            if (file != null) {
                result = ioStream.file_binary_open(file.getUri(), "a");
            }
        }
        return result;
    }

    public void saf_file_bin_rewrite(double _index) {
        ioStream.file_binary_rewrite(_index);
    }

    public void saf_file_bin_write_byte(double _index, double _value) {
        ioStream.file_binary_write_byte(_index, _value);
    }

    public double saf_file_bin_read_byte(double _index) {
        return ioStream.file_binary_read_byte(_index);
    }

    public void saf_file_bin_close(double _index) {
        ioStream.file_binary_close(_index);
    }


    /*  DEBUG  */
    public double send_double(double d) {
        return d;
    }

    public void send_social_log(String _text) {
        int map = RunnerJNILib.jCreateDsMap(null, null, null);
        RunnerJNILib.DsMapAddString(map, "type", "logged");
        RunnerJNILib.DsMapAddString(map, "content", _text);
        RunnerJNILib.CreateAsynEventWithDSMap(map, EVENT_ASYNC_SOCIAL);
    }


    /*  PRIVATE FUNCTIONS  */
    private String get_path_from_uri(Context _context, Uri _uri) {
        return RealPathUtil.getRealPathFromURI(_context, _uri);
    }

    private ArrayList<String> directory_parse(String _path) {
        ArrayList<String> paths = new ArrayList<>();
        for (String p : _path.split("/")) {
            p = p.trim();
            if (!p.equalsIgnoreCase("")) {
                paths.add(p);
            }
        }
        return paths;
    }

    private void file_copy(InputStream in, OutputStream out) throws IOException {
        byte[] buffer = new byte[8024];
        int n;
        long count = 0;

        while (-1 != (n = in.read(buffer))) {
            out.write(buffer, 0, n);
            count += n;
        }
    }

    private DocumentFile saf_directory_parse(DocumentFile root, String _path) {
        DocumentFile result = null;
        ArrayList<String> tree = directory_parse(_path);

        DocumentFile path = root;

        int size = tree.size();
        if (size == 0) {
            result = path;
        } else {
            for (int i = 0; i < size; i += 1) {
                String p = tree.get(i);
                DocumentFile find = path.findFile(p);

                if (find != null) {
                    path = find;
                    if (i == size - 1) {
                        result = path;
                    }
                }
            }
        }
        return result;
    }
}