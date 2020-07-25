using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Heat : MonoBehaviour
{
    private Material material;
    public float strength = 0.025f;
    public float noise = 6f;
    public float speed = 4f;

    private void Start()
    {
        material = new Material(Shader.Find("Custom/HeatHaze"));
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        material.SetFloat("_Speed", speed);
        material.SetFloat("_Strength", strength);
        material.SetFloat("_Noise", noise);
        Graphics.Blit(source, destination, material);
    }

}
