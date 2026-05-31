
package ${YYAndroidPackageName};
import ${YYAndroidPackageName}.R;
import com.yoyogames.runner.RunnerJNILib;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import java.io.File;

import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.InputStream;

import java.lang.Exception;

public class MobileUtils_Gallery extends RunnerSocial
{
	int MY_PERMISSIONS = 9;
	int EVENT_OTHER_SOCIAL = 70;
	
	Activity activity = RunnerActivity.CurrentActivity;
	
	static final int PICK_IMAGE_URI = 2;
	public void MobileUtils_Gallery_Open_Any()
    {
        Intent intent = new Intent(Intent.ACTION_PICK);
		intent.setType("image/*");
		activity.startActivityForResult(intent,PICK_IMAGE_URI);
    }
	public void MobileUtils_Gallery_Open_PNG()
    {
        Intent intent = new Intent(Intent.ACTION_PICK);
		intent.setType("image/png");
		activity.startActivityForResult(intent,PICK_IMAGE_URI);
    }
	
	@Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) 
	{
		if (resultCode == Activity.RESULT_OK)
		if (requestCode == PICK_IMAGE_URI) 
		{
			try
			{
				InputStream input = activity.getContentResolver().openInputStream(data.getData());
				File file = new File(activity.getFilesDir(),"gallerysoupy.jpg");
				
				
				OutputStream output = new FileOutputStream(file);
				byte[] buffer = new byte[4 * 1024];
				int read;
				while ((read = input.read(buffer)) != -1) 
					output.write(buffer, 0, read);
				output.flush();
				input.close();
				
				int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
				RunnerJNILib.DsMapAddString(dsMapIndex,"type","MobileUtils_Gallery_Open");
				RunnerJNILib.DsMapAddString(dsMapIndex,"path",String.valueOf(file));
				RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);   
			}
			catch (Exception e) 
			{
				e.printStackTrace();
			}
		}
	}
}