import Foundation

/// A library of 200+ cultural facts about Rajasthan, mandala art, flowers,
/// Indian crafts, and pattern design for the "Did You Know?" insight cards.
struct FactsLibrary {
    
    enum Category: String, CaseIterable {
        case rajasthanHistory = "Rajasthan History"
        case cities = "Cities of Rajasthan"
        case art = "Art & Craft"
        case flowers = "Flowers & Gardens"
        case patterns = "Patterns & Geometry"
        case festivals = "Festivals & Culture"
        case architecture = "Architecture"
        case textiles = "Textiles & Fabrics"
        case nature = "Nature & Wildlife"
        case music = "Music & Dance"
        case food = "Food & Cuisine"
        case mandala = "Mandala & Spiritual"
    }
    
    // Returns random facts for the given categories
    static func randomFacts(for categories: [Category], count: Int = 3) -> [String] {
        let pool = categories.flatMap { factsFor(category: $0) }
        guard !pool.isEmpty else { return [] }
        return Array(pool.shuffled().prefix(count))
    }
    
    // Returns a single random fact from a category
    static func randomFact(for category: Category) -> String {
        let facts = factsFor(category: category)
        return facts.randomElement() ?? "Rajasthan, the Land of Kings, is India's largest state by area."
    }
    
    // Returns all facts for a mood-based insight
    static func factsForMood(_ moodKey: String) -> [String] {
        switch moodKey {
        case "Calm & Centered":
            return randomFacts(for: [.mandala, .architecture, .nature], count: 3)
        case "Energetic & Vibrant":
            return randomFacts(for: [.festivals, .music, .textiles], count: 3)
        case "Contemplative & Thoughtful":
            return randomFacts(for: [.rajasthanHistory, .architecture, .mandala], count: 3)
        case "Passionate & Bold":
            return randomFacts(for: [.art, .textiles, .festivals], count: 3)
        case "Harmonious & Balanced":
            return randomFacts(for: [.patterns, .architecture, .flowers], count: 3)
        case "Chaotic & Experimental":
            return randomFacts(for: [.art, .music, .festivals], count: 3)
        case "Joyful & Playful":
            return randomFacts(for: [.festivals, .food, .flowers], count: 3)
        case "Serene & Meditative":
            return randomFacts(for: [.mandala, .nature, .architecture], count: 3)
        case "Mystic & Dreamy":
            return randomFacts(for: [.mandala, .rajasthanHistory, .nature], count: 3)
        case "Grounded & Steady":
            return randomFacts(for: [.architecture, .rajasthanHistory, .nature], count: 3)
        case "Radiant & Warm":
            return randomFacts(for: [.flowers, .festivals, .food], count: 3)
        case "Intricate & Detailed":
            return randomFacts(for: [.patterns, .art, .textiles], count: 3)
        default:
            return randomFacts(for: [.rajasthanHistory, .art, .flowers], count: 3)
        }
    }
    
    // MARK: - Fact Database (200+)
    
    static func factsFor(category: Category) -> [String] {
        switch category {
        case .rajasthanHistory:
            return [
                "Rajasthan means 'Land of Kings' in Sanskrit, derived from 'Raja' (king) and 'Sthan' (place). It became a state of India on 30 March 1949.",
                "The Rajput clans ruled Rajasthan for over 1,000 years. There were 22 princely states that merged to form modern Rajasthan.",
                "Maharana Pratap of Mewar is considered one of the greatest Rajput warriors. His horse Chetak is equally legendary and has a memorial in Haldighati.",
                "The Battle of Haldighati (1576) between Maharana Pratap and Akbar's forces is one of the most famous battles in Indian history.",
                "The Thar Desert covers about 60% of Rajasthan's area, making it the largest state in India by land area at 342,239 sq km.",
                "Rajput women practiced 'Jauhar' — mass self-immolation — to preserve honor when defeat in battle was certain. Chittorgarh witnessed three Jauhars.",
                "The Rajput kingdoms were known for their code of honor called 'Rajputana Dharma' which emphasized valor, chivalry, and protection of the weak.",
                "Rana Sanga of Mewar united most of the Rajput clans and was one of the most powerful kings in India before the Mughals.",
                "Prithviraj Chauhan III was the last major Hindu king to rule from Delhi and Ajmer before the Islamic conquests of India.",
                "The Marwar kingdom of Jodhpur was founded by Rao Jodha in 1459, who also built the magnificent Mehrangarh Fort.",
                "Rajasthan's Shekhawati region is called the 'Open Air Art Gallery' due to its hundreds of ornately painted havelis.",
                "The Bishnoi community of Rajasthan, founded in 1485, are among the world's earliest environmentalists, protecting trees and wildlife for over 500 years.",
                "Rajasthan was historically divided into nine regions: Mewar, Marwar, Hadoti, Dhundhar, Shekhawati, Mewat, Vagad, Gorwar, and Matsya.",
                "The Ranthambore Fort in Sawai Madhopur dates back to 944 AD and is one of the oldest hill forts in Rajasthan.",
                "Bappa Rawal founded the Mewar dynasty in 734 AD. His descendants ruled for an unbroken period of over 1,300 years.",
                "The great wall of Kumbhalgarh Fort is the second longest wall in the world after the Great Wall of China, stretching 36 km.",
                "Maharaja Sawai Jai Singh II founded Jaipur in 1727, making it one of India's first planned cities with a grid layout."
            ]
            
        case .cities:
            return [
                "Jaipur is called the Pink City because Maharaja Ram Singh had the entire old city painted pink in 1876 to welcome Prince Albert.",
                "Jodhpur is known as the Blue City because houses near the Mehrangarh Fort are painted blue with indigo-limestone wash, originally done by Brahmins.",
                "Udaipur, the City of Lakes, has five major interconnected lakes: Pichola, Fateh Sagar, Udai Sagar, Swaroop Sagar, and Doodh Talai.",
                "Jaisalmer's entire fort is a living fort — about 3,000 people still live within its golden sandstone walls, making it one of the world's largest inhabited forts.",
                "Bikaner was founded in 1488 by Rao Bika. The Junagarh Fort in Bikaner is one of the few major forts in Rajasthan not built on a hilltop.",
                "Pushkar is one of the oldest cities in India, believed to have been created when Lord Brahma dropped a lotus flower from his hand.",
                "Chittorgarh Fort is the largest fort in India, spreading over 700 acres. It has 65 historic structures including palaces, temples, and towers.",
                "Mount Abu is Rajasthan's only hill station and home to the Dilwara Temples, considered to be among the finest marble structures in the world.",
                "Ajmer houses the Dargah Sharif of Sufi saint Moinuddin Chishti, one of the most important pilgrimage sites in India for Muslims.",
                "Bundi is famous for its step wells (baoris). The Rani ji ki Baori in Bundi is one of the largest and most ornate step wells in India.",
                "Alwar was the first princely state to join the Indian Union in 1949. The Bala Quila fortress in Alwar predates the Mughal era.",
                "Kota on the Chambal River is famous for its school of miniature paintings known as the Kota School, dating from the 17th century.",
                "Nathdwara near Udaipur houses the famous Shrinathji Temple, where the tradition of Pichwai paintings originated to adorn the temple.",
                "Barmer in western Rajasthan is famous for its embroidery, woodcarving, and the ajrakh block printing tradition.",
                "Sawai Madhopur is named after Maharaja Sawai Madho Singh I and is the gateway to the famous Ranthambore Tiger Reserve.",
                "Tonk is called the 'Lucknow of Rajasthan' for its Nawabi culture and the stunning Sunehri Kothi (Golden Mansion) with gold leaf interiors.",
                "Jhalawar is the youngest district of Rajasthan, created in 1838. It has the Gagron Fort, a rare water fort at the confluence of two rivers."
            ]
            
        case .art:
            return [
                "Meenakari is the art of fusing colored glass onto gold using temperatures above 850°C. Jaipur became the Meenakari capital in the 16th century.",
                "Phad paintings from Shahpura are 700-year-old narrative scrolls depicting folk deities. Each scroll can be up to 30 feet long.",
                "The Joshi family has been the sole lineage of Phad painters for over 700 years, passing the tradition from father to son.",
                "Blue Pottery of Jaipur uses no clay — it's made from quartz stone powder, glass, and multani mitti with cobalt oxide for the blue color.",
                "Thewa art from Pratapgarh involves fusing 23-karat gold sheets onto molten colored glass. Only a few families know this 400-year-old technique.",
                "Pichwai paintings from Nathdwara depict Lord Krishna and are hung behind the deity in temples. Each painting can take 6-8 months to complete.",
                "Miniature paintings of Rajasthan originated from the Mughal style but developed distinct regional schools — Mewar, Marwar, Bundi, Kota, Jaipur, and Kishangarh.",
                "The Kishangarh school of painting is famous for the 'Bani Thani' painting, often called India's Mona Lisa, depicting a beautiful court lady.",
                "Kundan jewelry from Jaipur involves setting uncut diamonds and gemstones in gold foil. It's one of the oldest forms of jewelry making in India.",
                "Lac bangles from Jaipur are made by coating lac (a natural resin) over a core and embedding glass beads, mirrors, and stones.",
                "Rajasthani puppetry (Kathputli) uses string puppets made from mango wood and cotton. Each puppet can have up to 5 strings for movement.",
                "Mandana is a form of ritual floor painting done by women in Rajasthan using chalk and red ochre, depicting geometric patterns for protection.",
                "Sanjhi art involves creating intricate paper-cut designs using colored stencils, traditionally done on temple walls during Krishna's birthday.",
                "The marble carving tradition of Makrana has been alive for over 400 years. Makrana marble was used to build the Taj Mahal.",
                "Rajasthani terracotta art dates back to the Indus Valley Civilization. The Molela village near Udaipur still produces terracotta plaques of deities.",
                "The Meenakari work of Jaipur is the only tradition in the world that applies enamel on both sides of jewelry — front and back.",
                "Zardozi embroidery in Rajasthan uses gold and silver threads on fabric. A single bridal outfit can take 6 months to embroider.",
                "Dabu print from Akola village in Chittorgarh uses mud-resist printing with natural dyes, an eco-friendly technique over 500 years old."
            ]
            
        case .flowers:
            return [
                "Marigold (Genda) is sacred in Indian culture and is used in every festival, wedding, and religious ceremony in Rajasthan.",
                "The Pushkar Rose Garden grows the famous Pushkar rose, used to make rose water, gulkand, and attar (essential oil) for centuries.",
                "Lotus (Kamal) is India's national flower. It grows in the sacred Pushkar Lake and symbolizes purity, beauty, and spiritual awakening.",
                "Jasmine (Mogra) is called the 'Queen of the Night' because its scent intensifies after sunset. Women wear it in their hair during festivals.",
                "The Champa flower (Plumeria) is associated with temple worship in Rajasthan. Its sweet fragrance is believed to attract positive energy.",
                "Rajasthani women create Rangoli patterns using flower petals during Diwali, making intricate floor mandalas at their doorsteps each morning.",
                "The Desert Rose (Adenium) thrives in the Thar Desert. Despite the harsh climate, it produces vibrant pink and red blooms.",
                "Rajasthan's Keoladeo National Park in Bharatpur hosts over 350 species of flowering plants and is a UNESCO World Heritage Site.",
                "The Sunflower (Surajmukhi) fields of eastern Rajasthan bloom in winter. The flowers always face east, following the sun's path.",
                "Hibiscus (Gudhal) is offered to Goddess Kali and Lord Ganesh in Rajasthani temples. Its petals are also used in herbal teas.",
                "The Bougainvillea vine was brought to India by Portuguese traders and now adorns many Rajasthani havelis and palace walls.",
                "Rose cultivation in Pushkar and Ajmer produces over 300 tonnes of rose petals annually for rose water and essential oils.",
                "Henna (Mehendi) comes from the Lawsonia plant native to Rajasthan. Applying henna patterns on hands is a centuries-old tradition.",
                "The Kachnar tree blooms with orchid-like purple flowers in spring and is used in Rajasthani cuisine as a vegetable.",
                "Parijat (Night Jasmine) flowers fall from the tree at dawn and are collected fresh for temple offerings across Rajasthan.",
                "Gulmohar (Royal Poinciana) trees create canopies of fire-red flowers across Rajasthani cities from April to June.",
                "The sacred Tulsi (Holy Basil) plant is found in every Rajasthani household. It is worshipped daily as a form of Goddess Lakshmi.",
                "Dahlia flowers were introduced to India from Mexico in the 19th century and now bloom magnificently in Rajasthan's winter flower shows."
            ]
            
        case .patterns:
            return [
                "Jali latticework in Rajasthani palaces uses geometric patterns based on Islamic and Hindu sacred geometry, combining stars, hexagons, and arabesques.",
                "Rangoli patterns in Rajasthan use sacred geometry — circles, triangles, and squares represent the sun, fire, and earth respectively.",
                "The mandala form appears in Hindu, Buddhist, and Jain traditions across Rajasthan. Jain temples feature some of the most complex mandala patterns.",
                "Rajasthani floor patterns (Mandana) use five basic shapes: circles (sun), triangles (mountains), wavy lines (water), dots (stars), and swastikas (well-being).",
                "The geometric patterns in Hawa Mahal's 953 windows follow the Fibonacci sequence, creating natural ventilation that cools the palace.",
                "Dilwara Temples in Mount Abu contain marble carvings so detailed that some domes have 72 individual carved panels forming a perfect mandala.",
                "Rajasthani textile patterns often use the 'buti' motif — a small repeating flower pattern that creates a rhythmic, meditative visual effect.",
                "The 'chhatri' (dome canopy) pattern seen on Rajasthani buildings follows octagonal symmetry, similar to mandala sacred geometry.",
                "Step well (baori) architecture in Rajasthan uses symmetrical patterns that mirror themselves as you descend, creating hypnotic geometric views.",
                "The ceiling of the Sheesh Mahal (Mirror Palace) in Amber Fort uses thousands of tiny mirrors arranged in geometric patterns to reflect candlelight.",
                "Rajasthani block printing uses wooden blocks carved with patterns repeating at exact intervals, requiring mathematical precision.",
                "Kolam patterns drawn outside South Indian temples influenced Rajasthani Mandana art, showing cultural exchange along trade routes.",
                "The Vaastu Purusha Mandala is a sacred geometric pattern used in all traditional Rajasthani palace and temple architecture.",
                "Geometric tile patterns in Rajasthani forts use only 5 shapes to create infinite non-repeating patterns, predating Penrose tiling by centuries.",
                "The 'Padma' (lotus) pattern in Rajasthani art uses 8-fold symmetry — eight petals representing the eight directions of the compass.",
                "Kundan jewelry settings follow precise geometric patterns. Each stone is placed to create mathematical symmetry in the final piece.",
                "Rajasthani mirror work (Shisha) uses small mirrors embedded in fabric or walls in geometric patterns, reflecting light to ward off evil."
            ]
            
        case .festivals:
            return [
                "The Pushkar Camel Fair attracts over 200,000 visitors and 50,000 camels, horses, and cattle. It's one of the world's largest livestock fairs.",
                "Gangaur is Rajasthan's most important women's festival, celebrating Goddess Gauri (Parvati). Women create elaborate clay idols and dress them in finery.",
                "Teej festival marks the onset of monsoon. Women swing on decorated jhulas (swings) while singing folk songs about rain and romance.",
                "The Desert Festival of Jaisalmer features camel races, turban-tying contests, and the famous 'Mr. Desert' competition.",
                "Diwali in Rajasthan is spectacular — the entire Nahargarh Fort in Jaipur is illuminated with thousands of oil lamps.",
                "Holi in Rajasthan starts with Holika Dahan bonfire and continues with colored powder and water fights for two full days.",
                "The Mewar Festival in Udaipur coincides with Gangaur. Women float decorated clay images of Goddess Gauri on Lake Pichola.",
                "Nagaur Fair is the second-largest cattle fair in India after Pushkar, famous for its red chili trading and bullock cart races.",
                "The Kite Festival (Uttarayan) on Makar Sankranti sees Jaipur's sky filled with millions of colorful kites. Night kite flying uses LED kites.",
                "Rajasthani weddings can last 5-7 days and involve over a dozen distinct rituals, each with its own traditional music and ceremony.",
                "The Elephant Festival in Jaipur features elephants decorated with vibrant paint, jewelry, and embroidered cloths. Polo is played from elephant back.",
                "During Navratri, Rajasthani women perform the Garba dance in circular formations, which mimics a mandala pattern when viewed from above.",
                "The Baneshwar Fair near Dungarpur is called the 'Tribal Kumbh' — it attracts over 100,000 Bhil tribal people for three days.",
                "Summer Festival in Mount Abu features folk dancing, music, boat races on Nakki Lake, and the sham-e-qawwali competition.",
                "Urs at Ajmer Dargah is a six-day festival honoring Sufi saint Moinuddin Chishti, attracting devotees from across the world.",
                "The Marwar Festival in Jodhpur celebrates the heroes of Rajasthan through folk music, especially the ballads of Marwari bards."
            ]
            
        case .architecture:
            return [
                "The Hawa Mahal in Jaipur has 953 small windows designed to allow royal women to observe street life without being seen.",
                "Mehrangarh Fort in Jodhpur sits on a 125-meter cliff and has walls up to 36 meters high and 21 meters thick.",
                "Amber Fort near Jaipur took 100 years to build (1592-1700) and blends Rajput and Mughal architectural styles.",
                "The Jantar Mantar in Jaipur contains the world's largest stone sundial (Samrat Yantra) at 27 meters tall, accurate to 2 seconds.",
                "Umaid Bhawan Palace in Jodhpur is one of the world's largest private residences with 347 rooms. It took 15 years and 3,000 workers to build.",
                "The City Palace of Udaipur overlooks Lake Pichola and was built over 400 years by 22 successive Maharanas of Mewar.",
                "Jaisalmer Fort is made entirely of yellow sandstone. Its walls glow golden at sunset, earning the name 'Sonar Qila' (Golden Fort).",
                "The Chand Baori step well in Abhaneri has 3,500 steps arranged in 13 stories, descending 64 feet into the earth.",
                "Junagarh Fort in Bikaner is the only major fort in Rajasthan built on flat ground rather than a hill.",
                "The Patwon Ki Haveli in Jaisalmer is the largest and most ornate haveli in Rajasthan, with 60 balconies and intricate stone carvings.",
                "Chittorgarh Fort's Tower of Victory (Vijay Stambh) is a 37-meter tower with 157 steps and intricate carvings on every surface.",
                "Lake Palace in Udaipur appears to float on Lake Pichola. It was built in 1746 as a royal summer retreat.",
                "The Taragarh Fort in Bundi is called the 'Star Fort' and has massive water reservoirs that can store water for years.",
                "Shekhawati havelis have over 10,000 painted frescoes showing everything from trains (that artists had never seen) to telephone lines.",
                "The Saheliyon ki Bari (Garden of Maidens) in Udaipur has fountains that work without any motor, using only water pressure from natural gradients.",
                "Ranthambore Fort is unique because it incorporates a working Hindu temple, Jain temples, mosques, and a Dargah within the same walls.",
                "The Sajjan Garh (Monsoon Palace) in Udaipur was built to watch monsoon clouds approaching from the Aravalli Hills."
            ]
            
        case .textiles:
            return [
                "Bandhani tie-dye is a 5,000-year-old art. Artisans tie up to 800 knots per hour, with a single sari containing over 16,000 hand-tied dots.",
                "Ajrakh block printing from Barmer uses natural indigo and madder dyes. Each cloth is washed, dyed, and printed up to 16 times.",
                "The Leheriya pattern (diagonal wave stripes) of Jaipur is created by rolling and tying fabric before dyeing, producing rainbow-like stripes.",
                "Bagru printing near Jaipur is one of India's oldest block printing traditions. The wooden blocks used can be over 300 years old.",
                "Rajasthani Dabu printing from Akola uses a mud-resist paste. The process involves 12 steps and takes over 20 days to complete.",
                "Gota Patti embroidery uses small pieces of gold/silver ribbon appliquéd onto fabric. A single bridal lehenga can have 50,000 pieces.",
                "Rajasthani mirror work (Shisha) originated as a way to add sparkle to clothing in the desert. Each mirror is individually hand-stitched.",
                "The 'Odhni' (head covering) of Rajasthani women tells their community, marital status, and region through its colors and patterns.",
                "Patola silk from Gujarat influenced Rajasthani double-ikat weaving. The technique requires both warp and weft threads to be dyed before weaving.",
                "Sanganer near Jaipur is the block-printing capital of India, with over 40,000 families involved in the textile printing industry.",
                "The famous 'Jaipuri Razai' (quilt) is filled with cotton and covered in hand-block-printed fabric, known for its warmth and lightness.",
                "Rajasthani camel leather craft (Mojari shoes) uses vegetable-tanned leather embroidered with gold thread — a tradition over 1,000 years old.",
                "The 'Pagdi' (turban) in Rajasthan indicates caste, region, and occasion. Jodhpuri turbans can be up to 9 meters long.",
                "Kota Doria fabric is a unique blend of cotton and silk woven in tiny squares. The translucent cloth is perfect for Rajasthan's hot climate.",
                "Zari work uses real gold and silver threads woven into silk. Jaipur is one of the three main centers of Zari production in India.",
                "Rajasthani Phulkari embroidery uses simple darning stitches to create complex geometric patterns entirely on the reverse side of the fabric."
            ]
            
        case .nature:
            return [
                "The Thar Desert is home to the State Animal of Rajasthan — the Chinkara (Indian gazelle), which can survive without water for long periods.",
                "Ranthambore National Park has one of the highest densities of Bengal tigers in the world, with around 80 tigers.",
                "The Great Indian Bustard, one of the heaviest flying birds weighing up to 18 kg, is critically endangered and found mainly in Rajasthan.",
                "The Aravalli Range running through Rajasthan is one of the world's oldest mountain ranges, formed over 350 million years ago.",
                "Keoladeo Ghana National Park in Bharatpur hosts over 350 bird species, including the rare Siberian crane that migrates 6,500 km.",
                "The Chambal River in Rajasthan is home to the critically endangered gharial crocodile, with fewer than 200 left in the wild.",
                "The Thar Desert receives less than 250mm of rain annually, yet supports over 140 species of birds.",
                "Desert foxes (Vulpes vulpes pusilla) in Rajasthan have evolved large ears to radiate heat and detect prey underground.",
                "The Sariska Tiger Reserve was the first reserve in the world to successfully translocate tigers from one reserve to another.",
                "Rajasthan's state bird is the Godavan (Great Indian Bustard). Its mating dance involves inflating a gular pouch to produce booming calls.",
                "The Khejri tree (Prosopis cineraria) is Rajasthan's state tree. In 1730, 363 Bishnoi villagers sacrificed their lives to protect Khejri trees.",
                "Tal Chhapar Sanctuary in Churu is famous for its blackbuck population and is Rajasthan's smallest wildlife sanctuary.",
                "The Desert National Park near Jaisalmer contains 180-million-year-old fossilized tree trunks, some of the oldest in India.",
                "The Sam Sand Dunes near Jaisalmer can reach heights of over 150 feet and shift position with the wind.",
                "Rajasthan has over 1,000 man-made lakes and tanks, developed over centuries to harvest the scarce monsoon rainfall.",
                "The Kumbalgarh Wildlife Sanctuary is home to wolves, leopards, and the four-horned antelope (Chousingha), found only in India.",
                "The pink flamingos that visit the Sambhar Salt Lake in Rajasthan migrate from as far as Central Asia, covering over 3,000 km."
            ]
            
        case .music:
            return [
                "Ghoomar is the traditional folk dance of Rajasthan, performed by women in flowing ghaghra skirts. Each spin represents the cosmic dance.",
                "The Manganiar and Langa communities of western Rajasthan are hereditary musicians who have preserved desert folk music for over 1,000 years.",
                "The Kamaicha is a unique Rajasthani stringed instrument with 17 strings, played by the Manganiar community with a horsehair bow.",
                "Kathputli puppet shows originated in Rajasthan over 1,000 years ago. The word means 'wooden doll' — kath (wood) and putli (doll).",
                "The Kalbeliya dance, performed by the snake charmer community, was inscribed as UNESCO Intangible Cultural Heritage in 2010.",
                "Sapera folk dance mimics the movement of serpents. Dancers wear black swirling skirts decorated with silver embroidery.",
                "The Ravanhatta is a bowed string instrument made from bamboo and coconut shell, believed to have been invented by the demon king Ravana.",
                "Pabuji Ki Phad is a musical storytelling tradition where bards sing the epic of folk deity Pabuji while unrolling painted scrolls.",
                "Bhopa and Bhopi are husband-and-wife storytellers who travel villages with large canvas paintings and narrate folk epics through song.",
                "The Algoza is a pair of bamboo flutes played simultaneously — one provides melody, the other drone. It requires circular breathing.",
                "Rajasthani wedding songs (Vivah Geet) are region-specific — Mewar, Marwar, and Shekhawati each have distinct musical traditions.",
                "The 'Maand' singing style of Rajasthan is similar to the semiclassical 'Thumri' of North India, known for its emotional depth.",
                "Chang drum played during Holi is made of a circular wooden frame with leather stretched over one side, beaten with sticks.",
                "Rajasthani Qawwali from Ajmer blends Sufi poetry with classical ragas, creating a devotional music form unique to the region.",
                "The Morchang (jaw harp) is a tiny iron instrument held between teeth and plucked, producing rhythmic twanging sounds in folk music."
            ]
            
        case .food:
            return [
                "Dal Baati Churma is Rajasthan's signature dish — hard wheat rolls baked in desert sand, served with lentils and a sweet crumbled mixture.",
                "Laal Maas is a fiery Rajasthani mutton curry made with mathania chillies from the Jodhpur region, which are both hot and deeply flavorful.",
                "Ghevar is a disc-shaped sweet made during Teej festival, soaked in sugar syrup and topped with rabdi. Making it requires expert timing.",
                "Rajasthani cuisine developed largely without water — many dishes use buttermilk, ghee, and dried ingredients due to desert water scarcity.",
                "Ker Sangri is a unique Rajasthani dish made from desert beans and berries. It's prepared from plants that grow wild in the Thar Desert.",
                "The Rajasthani thali can contain up to 36 different items served in small bowls (katoris) arranged in a specific traditional order.",
                "Mirchi Vada (chili fritters) from Jodhpur are so famous that the city has outlets selling them on every major street.",
                "Pyaaz Kachori from Jaipur's old city is a deep-fried pastry stuffed with spiced onions. Some shops have been making it for over 100 years.",
                "Mawa Kachori from Jodhpur is stuffed with sweetened milk solids and dry fruits, then dipped in sugar syrup — sweet and savory combined.",
                "Rajasthani Kadhi is thicker than other Indian kadhis and uses dried dumplings (gatte) made from gram flour instead of fresh ones.",
                "Makhaniya Lassi from Jodhpur is a thick buttermilk drink topped with a layer of cream (malai) and saffron — served in earthen cups.",
                "The tradition of 'Baavla Baati' involves burying wheat dough balls in hot desert sand and camel dung embers to bake them perfectly.",
                "Rajasthani cuisine uses the 'Papad' rolling technique where women gather in groups to roll thousands of papads for the entire year.",
                "The Mathania chilli from Jodhpur has a specific Geographical Indication tag. Its unique spice level comes from the arid soil and climate.",
                "Churma Ladoo is made by crushing baked baati, mixing with ghee and jaggery. It's an essential offering in Rajasthani temples."
            ]
            
        case .mandala:
            return [
                "The word 'Mandala' comes from Sanskrit meaning 'circle' or 'completion'. It represents the universe in Hindu and Buddhist cosmology.",
                "In Rajasthani tradition, women draw mandala-like Rangoli patterns at their doorsteps daily, using rice flour, chalk, and flower petals.",
                "The Yantra, a geometric diagram used in Hindu meditation, is essentially a mandala. The Sri Yantra has 43 triangles forming 9 interlocking levels.",
                "Jain temples in Rajasthan feature ceiling mandalas carved in white marble, representing the cosmos with Mount Meru at the center.",
                "The Chakra system in Yoga visualizes 7 energy centers as colored mandalas along the spine, each with specific petal counts and geometry.",
                "The circular layout of many Rajasthani forts follows mandala principles — concentric rings of walls with the palace at the center.",
                "Sand mandalas in Tibetan Buddhism are destroyed after creation to symbolize impermanence — a concept shared with Rajasthani Sanjhi art.",
                "The lotus mandala (Padma) is the most common form, symbolizing purity arising from muddy waters — a metaphor for spiritual growth.",
                "In Ayurveda, mandala diagrams map the body's energy flow. Rajasthani Vaidyas (healers) use them in diagnostic practices.",
                "The 'Vastu Purusha Mandala' divides space into a sacred grid. All traditional Rajasthani architecture follows this mandala blueprint.",
                "Carl Jung studied mandalas and proposed they represent the 'Self' — a psychological wholeness that our unconscious strives toward.",
                "The symmetry in mandalas activates both brain hemispheres. Studies show coloring mandalas reduces anxiety by 38% on average.",
                "Rajasthani 'Thikri' art places mirror fragments in geometric mandala patterns on palace walls to create kaleidoscopic reflections.",
                "The concept of 'Bindu' (center point) in mandala design represents the source of creation — the point from which all patterns emerge.",
                "Buddhist monks can take up to 3 months to create a single sand mandala using funnels of colored sand, one grain at a time.",
                "Mandala-like patterns appear in Islamic geometric art found in Rajasthani mosques, using only compass and straightedge construction.",
                "The Ajmer Sharif Dargah's marble floor features mandala-like patterns combining Hindu geometric tradition with Islamic arabesques.",
                "In traditional Rajasthani homes, the 'Chowk' (central courtyard) is designed as a mandala — the family's sacred center of daily life."
            ]
        }
    }
}
