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

    private void Awake()
    {
        material = new Material(Shader.Find("Custom/EyeBlink"));

    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        material.SetFloat("_height", height);
        material.SetFloat("_width", width);
        material.SetFloat("_blurSize", blur);
        material.SetFloat("_sharpness", sharpness);
        material.SetColor("_Color", color);
        Graphics.Blit(source, destination, material);
    }
}
