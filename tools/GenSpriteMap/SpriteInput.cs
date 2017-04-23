using System.Collections.Generic;

namespace GenSpriteMap
{
    class SpriteInput
    {
        public string name { get; set; }
        public List<string> frames { get; set; }
        public int frameRate { get; set; }
        public bool looped { get; set; }
        public bool flipX { get; set; }
        public bool flipY { get; set; }
    }
}
