package ${YYAndroidPackageName};
import ${YYAndroidPackageName}.R;
import com.yoyogames.runner.RunnerJNILib;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Environment;

import java.io.File;
import java.io.FileOutputStream;

import androidx.core.content.ContextCompat;
import android.Manifest;
import android.os.Build;

import android.os.StrictMode;
import android.provider.Settings;

import android.util.Log;

import java.io.FileInputStream;
import java.nio.channels.FileChannel;

import androidx.core.content.FileProvider;

import android.content.pm.ResolveInfo;
import java.util.List;
import android.content.pm.PackageManager;
import 	android.webkit.MimeTypeMap;
import android.content.Context;

public class MobileUtils_Share extends RunnerSocial
{	
	Activity activity = RunnerActivity.CurrentActivity;
	
	public void copy(File src, File dst) throws Exception 
	{
		FileInputStream inStream = new FileInputStream(src);
		FileOutputStream outStream = new FileOutputStream(dst);
		FileChannel inChannel = inStream.getChannel();
		FileChannel outChannel = outStream.getChannel();
		inChannel.transferTo(0, inChannel.size(), outChannel);
		Log.i("yoyo","File Size: " + String.valueOf(inChannel.size()));
		inStream.close();
		outStream.close();
	}
	
	
	public void shareFile(Context context, File file) {
		
		if (!file.exists()) {
			Log.i("yoyo","File not found!");
			return;
		}

		Log.i("yoyo","PackageName: " + context.getPackageName());

		Uri fileUri = FileProvider.getUriForFile(
			context,
			context.getPackageName() + ".fileprovider",
			file
		);
		
		String mimeType = getMimeType(file.getAbsolutePath());
		
		Intent shareIntent = new Intent(Intent.ACTION_SEND);
		shareIntent.setType(mimeType != null ? mimeType : "*/*");
		shareIntent.putExtra(Intent.EXTRA_STREAM, fileUri);
		shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

		context.startActivity(Intent.createChooser(shareIntent, "Share file using"));
	}
	
		public String getMimeType(String path) {
			String extension = MimeTypeMap.getFileExtensionFromUrl(path);
			if (extension != null) {
				return MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension.toLowerCase());
			}
			return null;
		}
	
	
    public double MobileUtils_Share_Open(String Title_text,String MIME,String value)
	{
		StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
		StrictMode.setVmPolicy(builder.build());
		
        Intent i = new Intent();
        i.setAction(Intent.ACTION_SEND);
		i.setType(MIME);
		
		switch(MIME)
		{
			case "text/plain":
			case "text/rtf":
			case "text/html":
			case "text/json":
				i.putExtra(Intent.EXTRA_TEXT, value);
			break;
			
			default:
			
				// i.putExtra(Intent.EXTRA_TEXT, Title_text);
			
				File localFile = new File(activity.getFilesDir() + "/" + value);
				Log.i("yoyo",activity.getFilesDir() + "/" + value);
				
				File newFile = new File(activity.getExternalFilesDir(null), value); 
				
				try
				{
					Log.i("yoyo","Copying....");
					copy(localFile,newFile);
					Log.i("yoyo","Copy SUCCESS");
				}
				catch(Exception e)
				{
					Log.i("yoyo","Copy Failed");
					return -2.0;
				}
				
				shareFile(activity,newFile);
				
				return 1.0;//break;
		}
        
		// i.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
		
		

        activity.startActivity(Intent.createChooser(i,Title_text));
		// activity.startActivity(i);
		
		return 1.0;
    }	
}

