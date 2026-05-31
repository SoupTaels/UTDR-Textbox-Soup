
package ${YYAndroidPackageName};
import ${YYAndroidPackageName}.R;
import com.yoyogames.runner.RunnerJNILib;

import android.app.Activity;
import android.util.Log;

import java.io.File;

import java.io.FileOutputStream;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import java.lang.Exception;

import androidx.core.content.FileProvider;

public class MobileUtils_ImageTools extends RunnerSocial
{
	int MY_PERMISSIONS = 9;
	int EVENT_OTHER_SOCIAL = 70;
	
	Activity activity = RunnerActivity.CurrentActivity;
	
	public double MobileUtils_Image_Width(String path)
	{
		Bitmap bitmap = BitmapFactory.decodeFile(path);
		return (double) bitmap.getWidth();
	}
	
	public double MobileUtils_Image_Height(String path)
	{
		Bitmap bitmap = BitmapFactory.decodeFile(path);
		return (double) bitmap.getHeight();
	}
	
	public void MobileUtils_Image_Resize(String path,double W, double H)
	{
		Bitmap bitmap = BitmapFactory.decodeFile(path);
		Bitmap resizedBitmap = Bitmap.createScaledBitmap(bitmap,(int) W,(int) H, false);
		
		try
		{
			File file = new File(path);
			FileOutputStream fOut = new FileOutputStream(file);
			resizedBitmap.compress(Bitmap.CompressFormat.PNG, 100, fOut);
			fOut.flush();
			fOut.close();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	public void MobileUtils_Image_Crop(String path,double W, double H,double offset_x,double offset_y)
	{
		Bitmap bitmap = BitmapFactory.decodeFile(path);
		Bitmap cropedBitmap = Bitmap.createBitmap(bitmap, (int)offset_x,(int)offset_y,(int) W,(int) H);
		
		try
		{
			File file = new File(path);
			FileOutputStream fOut = new FileOutputStream(file);
			cropedBitmap.compress(Bitmap.CompressFormat.PNG, 100, fOut);
			fOut.flush();
			fOut.close();
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
	}
}

