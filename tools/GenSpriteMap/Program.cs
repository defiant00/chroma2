using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;

namespace GenSpriteMap
{
    class Program
    {
        static void Main(string[] args)
        {
            var spriteSheet = new Bitmap(2048, 2048, PixelFormat.Format32bppArgb);
            var g = Graphics.FromImage(spriteSheet);

            var areas = new List<Rectangle>();
            areas.Add(new Rectangle(0, 0, spriteSheet.Width, spriteSheet.Height));

            string sourcePath = "..\\..\\..\\sprites\\";

            var indexLookup = new Dictionary<string, int>();
            var outSprites = new SpriteOutput();

            foreach (string file in Directory.EnumerateFiles(sourcePath, "*.png"))
            {
                indexLookup[file.Replace(sourcePath, "").Replace(".png", "")] = indexLookup.Count;

                bool placed = false;
                var img = Image.FromFile(file);
                for (int i = 0; i < areas.Count && !placed; i++)
                {
                    var area = areas[i];
                    if (img.Width <= area.Width && img.Height <= area.Height)
                    {
                        outSprites.areas.Add(new SpriteOutArea { x = area.X, y = area.Y, width = img.Width, height = img.Height });

                        g.DrawImage(img, new Rectangle(area.Location, img.Size));
                        areas.RemoveAt(i);
                        if (img.Height < area.Height)
                        {
                            areas.Insert(i, new Rectangle(area.X, area.Y + img.Height, area.Width, area.Height - img.Height));
                        }
                        if (img.Width < area.Width)
                        {
                            areas.Insert(i, new Rectangle(area.X + img.Width, area.Y, area.Width - img.Width, img.Height));
                        }
                        placed = true;
                    }
                }
                if (!placed)
                {
                    throw new Exception(file + " won't fit!");
                }
            }

            var inSprites = JsonConvert.DeserializeObject<List<SpriteInput>>(File.ReadAllText(sourcePath + "sprites.json"));
            outSprites.sprites = inSprites.Select(i => new SpriteOutItem
            {
                name = i.name,
                indices = i.frames.Select(f => indexLookup[f]).ToList(),
                frameRate = i.frameRate,
                looped = i.looped,
                flipX = i.flipX,
                flipY = i.flipY
            }).ToList();

            spriteSheet.Save("..\\..\\..\\..\\assets\\images\\sprites.png", ImageFormat.Png);
            File.WriteAllText("..\\..\\..\\..\\assets\\data\\sprites.json", JsonConvert.SerializeObject(outSprites, Formatting.Indented));

            Console.WriteLine("Done, press any key...");
            Console.ReadKey();
        }
    }
}
