using System.Collections.Generic;

namespace GenSpriteMap
{
    class SpriteOutput
    {
        public List<SpriteOutArea> areas { get; set; }
        public List<SpriteOutItem> sprites { get; set; }

        public SpriteOutput()
        {
            areas = new List<SpriteOutArea>();
            sprites = new List<SpriteOutItem>();
        }
    }

    class SpriteOutArea
    {
        public int x { get; set; }
        public int y { get; set; }
        public int width { get; set; }
        public int height { get; set; }
    }

    class SpriteOutItem
    {
        public string name { get; set; }
        public List<int> indices { get; set; }
        public int frameRate { get; set; }
        public bool looped { get; set; }
        public bool flipX { get; set; }
        public bool flipY { get; set; }
    }
}
