package com.epicgames.ue4;

import com.YourCompany.HorizonUIPluginDemo.OBBDownloaderService;
import com.YourCompany.HorizonUIPluginDemo.DownloaderActivity;


public class DownloadShim
{
	public static OBBDownloaderService DownloaderService;
	public static DownloaderActivity DownloadActivity;
	public static Class<DownloaderActivity> GetDownloaderType() { return DownloaderActivity.class; }
}

