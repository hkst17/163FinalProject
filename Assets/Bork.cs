﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bork : MonoBehaviour
{
	public ParticleSystem left;
	public ParticleSystem right;
	int buffer = 0;
	bool l = true;

	// Use this for initialization
	void Start()
	{
		left.Play();
		right.Play();
	}

	// Update is called once per frame
	void Update()
	{
		buffer ++;
		// consolidate spectral data to 8 partitions (1 partition for each rotating cube)
		int numPartitions = 8;
		float[] aveMag = new float[numPartitions];
		float partitionIndx = 0;
		int numDisplayedBins = 512 / 2; //NOTE: we only display half the spectral data because the max displayable frequency is Nyquist (at half the num of bins)

		for (int i = 0; i < numDisplayedBins; i++)
		{
			if (i < numDisplayedBins * (partitionIndx + 1) / numPartitions)
			{
				aveMag[(int)partitionIndx] += AudioPeer.spectrumData[i] / (512 / numPartitions);
			}
			else
			{
				partitionIndx++;
				i--;
			}
		}

		// scale and bound the average magnitude.
		for (int i = 0; i < numPartitions; i++)
			aveMag[i] = (aveMag[i] * 100 > 3 ? 3 : aveMag[i] * 100) * 100;

		// aveMag = (aveMag * 100 > 1 ? 1 : aveMag * 100) * 100;
		Debug.Log(aveMag[0]);

		// transform.localScale = Vector3.one * aveMag;
		if (aveMag[0] > 150 && buffer >10){
			if(l)
				left.Emit((int)aveMag[0]/10);
			else
				right.Emit((int)aveMag[0]/10);
			l = !l;
			buffer = 0;
		}


	}


}
