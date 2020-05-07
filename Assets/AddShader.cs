using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AddShader : MonoBehaviour
{
    private Material material;
    public float height = 1;
    public float width = 1;
    public float blur = 1;
    [Range(0, 1)]
    public float sharpness = 1f;
    public Color color;

    private float heightSpeed = 0f;
    private float blurSpeed = 0f;

    private void Start()
    {
        material = new Material(Shader.Find("Custom/EyeBlink"));
        heightSpeed = UnityEngine.Random.Range(1.5f, 2f);
        blurSpeed = UnityEngine.Random.Range(1.25f, 1.8f);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        material.SetFloat("_height", height  / heightSpeed);
        material.SetFloat("_width", width);
        material.SetFloat("_blurSize", blur * blurSpeed);
        material.SetFloat("_sharpness", sharpness);
        material.SetColor("_Color", color);
        Graphics.Blit(source, destination, material);
    }

    private void Update()
    {
        if(material.GetFloat("_height") == 0)
        {
            heightSpeed = UnityEngine.Random.Range(0.7f, 1f);
            blurSpeed = UnityEngine.Random.Range(0.25f, 0.6f);
        }
    }
}
