package ${YYAndroidPackageName};
import ${YYAndroidPackageName}.R;
import com.yoyogames.runner.RunnerJNILib;

import android.util.Log;

import android.os.Vibrator;
import android.os.VibrationEffect;

import android.app.Activity;

public class MobileUtils_Vibrate extends RunnerSocial
{
	
	Activity activity = RunnerActivity.CurrentActivity;
	
	public void MobileUtils_Vibrate_Predefined(double kind)
	{
		((Vibrator) activity.getSystemService(Activity.VIBRATOR_SERVICE)).vibrate(VibrationEffect.createPredefined((int) kind));
	}

	public void MobileUtils_Vibrate_Shot(double milliseconds)
	{
		int amplitude = 255/2;
		((Vibrator) activity.getSystemService(Activity.VIBRATOR_SERVICE)).vibrate(VibrationEffect.createOneShot((long)milliseconds,amplitude));

	}

	public double MobileUtils_Vibrate_Is_Available()
	{
		Vibrator vibrator = (Vibrator) activity.getSystemService(Activity.VIBRATOR_SERVICE);
		
		if (vibrator != null && vibrator.hasVibrator()) {
			return 1.0;
		} else {
			return 0.0;
		}

	}
}

