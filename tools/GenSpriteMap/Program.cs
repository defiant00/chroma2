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
            int dim = 512;
            var spriteSheet = new Bitmap(dim, dim, PixelFormat.Format32bppArgb);
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
                var outerSize = new Point(img.Width + 2, img.Height + 2);
                for (int i = 0; i < areas.Count && !placed; i++)
                {
                    var area = areas[i];
                    if (outerSize.X <= area.Width && outerSize.Y <= area.Height)
                    {
                        outSprites.areas.Add(new SpriteOutArea { x = area.X + 1, y = area.Y + 1, width = img.Width, height = img.Height });

                        // Top-left pixel
                        g.DrawImage(img, new Rectangle(area.Location, new Size(1, 1)), new Rectangle(0, 0, 1, 1), GraphicsUnit.Pixel);
                        // Top-right pixel
                        g.DrawImage(img, new Rectangle(area.Location.X + img.Width + 1, area.Location.Y, 1, 1), new Rectangle(img.Width - 1, 0, 1, 1), GraphicsUnit.Pixel);
                        // Bottom-left pixel
                        g.DrawImage(img, new Rectangle(area.Location.X, area.Location.Y + img.Height + 1, 1, 1), new Rectangle(0, img.Height - 1, 1, 1), GraphicsUnit.Pixel);
                        // Bottom-right pixel
                        g.DrawImage(img, new Rectangle(area.Location.X + img.Width + 1, area.Location.Y + img.Height + 1, 1, 1), new Rectangle(img.Width - 1, img.Height - 1, 1, 1), GraphicsUnit.Pixel);
                        // Top row
                        g.DrawImage(img, new Rectangle(area.Location.X + 1, area.Location.Y, img.Width, 1), new Rectangle(0, 0, img.Width, 1), GraphicsUnit.Pixel);
                        // Left row
                        g.DrawImage(img, new Rectangle(area.Location.X, area.Location.Y + 1, 1, img.Height), new Rectangle(0, 0, 1, img.Height), GraphicsUnit.Pixel);
                        // Right row
                        g.DrawImage(img, new Rectangle(area.Location.X + img.Width + 1, area.Location.Y + 1, 1, img.Height), new Rectangle(img.Width - 1, 0, 1, img.Height), GraphicsUnit.Pixel);
                        // Bottom row
                        g.DrawImage(img, new Rectangle(area.Location.X + 1, area.Location.Y + img.Height + 1, img.Width, 1), new Rectangle(0, img.Height - 1, img.Width, 1), GraphicsUnit.Pixel);
                        // Main image
                        g.DrawImage(img, area.Location.X + 1, area.Location.Y + 1, img.Size.Width, img.Size.Height);
                        areas.RemoveAt(i);
                        if (outerSize.Y < area.Height)
                        {
                            areas.Insert(i, new Rectangle(area.X, area.Y + outerSize.Y, area.Width, area.Height - outerSize.Y));
                        }
                        if (outerSize.X < area.Width)
                        {
                            areas.Insert(i, new Rectangle(area.X + outerSize.X, area.Y, area.Width - outerSize.X, outerSize.Y));
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
