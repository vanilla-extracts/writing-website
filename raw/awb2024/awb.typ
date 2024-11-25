#import "@preview/hydra:0.5.1": hydra
#import "@preview/weave:0.2.0": compose_ as c

#set text(font: "Literata")
#set par(justify: true)
#set page(
  "a5",
  numbering: "1/1",
  margin: (outside: 1cm, inside: 2cm),
  footer: context {
    let page = counter(page)
    let n = page.get().first()
    stack(
      dir: ltr,
      if calc.rem(n, 3) == 1 {
        text(
          10pt,
          rgb(black).lighten(30%),
        )[This book is under the CC-BY-NC-SA 4.0 License, available
          #link("https://writing.charlotte-thoms.me/#awb2024", "here")]
      } else {
        []
      },
      h(1fr),
      [#page.display("1")],
    )
  },
  header: context {
    if calc.odd(here().page()) {
      stack(
        dir: ltr,
        align(left, [_A Witchy Best Friend_]),
      )
    } else {
      align(right, emph(hydra(1)))
    }
  },
)

#let title = [*A Witchy Best Friend (2024)*\ Charlotte O. Thomas
  \ _Last updated #datetime.today().display("[year]-[month]-[day]")_]

#v(1fr)
#set text(size: 24pt)
#set align(center)
#title
#set align(left)
#v(1fr)
#pagebreak(weak: true)

#set text(
  size: 12.5pt,
  hyphenate: false,
  number-type: "old-style",
  number-width: "proportional",
)


#outline(title: "Table of Chapters")

#let middle = c((
  block.with(width: 100%),
  align.with(center),
  strong,
))[$ast.basic$~$ast.basic$~$ast.basic$]


#set heading(numbering: "I. ")
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  pagebreak(to: "odd")
  v(1em)
  set align(center)
  set text(size: 16pt, weight: "bold")
  if counter(heading).get().first() == 3 {
    [#emph(it.body)]
  } else {
    [Chapter
      #counter(heading).display("I. ") \ #emph(it.body)]
  }
  v(2em)
}

= Coming Out <co>
#[
  Ophelie was walking, nervously, in the direction of the Girls’ Dorm to meet her
  best friend - Clara. They made a point of having a weekly movie night they
  dubbed the _Dumb Film Festival_, they started it two months into their
  first term at Uni.

  It was very effective for them to relax and blow off some steam accumulated
  during the week.

  This time, however, she wasn’t _just_ walking for their weekly movie night, you
  see, Ophelie had a secret, she _was a girl_. Okay, it might sound obvious, but
  for the doctors who assigned her birth gender, it was apparently not!

  A secret she had carried, alone, for far too long, so this time, she was going to
  come out to her best friend, she was queer too - a lesbian, as far as Ophelie
  knew - thus she had high hopes her friend would accept her.

  She smiled as she remembered the memories of growing up together and the long hours
  of mischief they played together. All of this coalesced in a big smile and a
  flutter in Ophelie’s stomach as her crush bubbled to the surface for a minute.

  She gulped, _hard_, she was in front of her door, she just had to knock, come
  out, and kiss, right?

  That wasn’t _so hard_ was it?

  #middle

  After goddess knew how many minutes - or hours? - of silence and anxiety she
  steadied herself and worked up the courage to knock on the door… Just for it
  to open in front of her.

  “Oh, E. You’re here, you’re late you know that?” Clara smirked

  The view of her best friend - and crush - smugly smirking like that _did things
to Ophelie_ but she kept on. “Yes, I’m here, and yes I know that. I _was_ on
  time, I just kept looking at the door too long” she said, her voice barely above
  a whisper, and with a distinctive _female_ quality which betrayed her voice
  training.

  Clara raised an eyebrow and muttered “‘Figures”, and let Ophelie enter the room.

  It was a fairly standard room, in the _Leonard Nimoy_‘s building, which housed
  the long-term dorms, for the girls, here at the Drama University of Northern
  Europe. The walls were far from bare, decorated tastefully with a lot of pride
  flags - so much she couldn’t see the one applying to her friend - and some old
  posters from her favourite shows.

  On the desk proudly stood a part-built model of the _USS Enterprise_, not the A,
  B, C, D, E, F or G. The _original_. Along with many sheets of paper, music,
  drama lessons, and lines to learn.

  “Okay let’s cho-” Clara started when Ophelie stopped her with a noise. More
  arching her eyebrows, Ophelie gulped _again_, it was now or never.

  “I have something to say yo-” Ophelie said as she was stopped when she felt a
  hug by her much taller friend, she was _the_ butch lesbian, as opposed to herself, she was
  small for a boy, about 160cm, which made her in the median height for girls her
  age.

  “Yeah, yeah, you’re trans, you’re a girl, she/her pronouns, the works, no shit
  Sherlock” Clara said, with her signature smug smirk.

  Ophelie was absolutely _stunned_. How? Why? Her mouth was ajar and she failed to
  compute what was happening, she regained her composure when she heard the distinctive sound of an old-school camera taking a photograph of her

  “Hey!” She said, pouting, to her friend.
  “Sorry E-, friend, you’re cute, but you’re oblivious as fuck if you thought we
  were not _knowing it_. I even think there were some bets on when you would come
  out.” Clara said, smiling softly

  “But I’m proud of you, so how come I don’t know it already?” She finished
  petting Ophelie’s hair.

  “Know what?” the latter said, still pouting.
  “Your name.”
  “Oh! It’s Ophelie, like _Ophelia_ but without the _a_ sound it’s a long _ee_
  sound it originates from-” She said excitedly.

  “Yeah yeah, nerd, so proud of you _Ophelie_” hearing her name said _like that_
  by her crush did a lot to the poor girl, “Let me prepare and I’ll do some shitty
  magic to _correct_ your body okay?” Clara grinned.

  “Thanks” Ophelie pouted, as Clara ruffled her hair.

  #v(1fr)

  “Wait, *_magic_*?”
]


= Magic <magic>

#[

  “Yeah, magic, I’m a Witch, why?” Clara said nonchalantly.
  Ophelie was *livid* and _flabbergasted_ (she didn’t think of this word,
  often but such a situation warranted it). Her friend, Clara, had said _magic?_.
  She knew the world had magical users, of course, it was common knowledge after
  all but it was _rare_.

  Few people could wield magical energies to their will, and most of them were
  weak, some telekinesis at best, maybe a fire starter, nothing more. Those
  born with _magical talent_ were rare, and usually picked up at sixteen years
  old to train in magical theory, in case you _were_ strong enough the State (or
  worse, the world) needed you.

  But she was twenty, and she assumed so, her friend was as well, what the hell
  was she doing in a _Drama University_ when she potentially had enough power to
  bend the rules of society in her favour? Ophelie calmed herself, Clara was her
  friend, she _wouldn’t_ use her or use magic on her without her consent she was
  _safe_.

  Clara saw how Ophelie reacted and cringed “I’m sorry Ophelie, I swear it’s
  nothing too important, yeah it’s _magic_ and yeah I have… more power than
  everyone would think I would but it’s _okay_, I will protect you really,
  believe me” She smiled softly and side-hugged her friend, who started crying
  softly.

  #middle

  After ten minutes - or maybe an hour - Ophelie stopped weeping and fell on
  her crush’s lap. She sighed “You really can wield magic? And what were you
  talking about with my body, you can _alter_ other people’s bodies? It’s a
  little… dangerous” Ophelie wimpered.

  “Yup, and well, it’s _more complicated than that_. I can alter other people’s
  bodies sure, but only with their conscious and unconscious consent, and then I
  can only make modifications which don’t contradict their internal image.” She
  explained, deep into magitheory.

  Ophelie stopped her “_Internal Image?_” she asked, she had _no idea_ what her
  friend was talking about. An _internal image_, magic, consent, it ringed up in
  her ears as she tried to parse and understand, but her mind was throwing
  parsing errors after parsing errors.

  Clara smiled softly “Yeah the _Internal Image_ of a person is their… well
  it’s how their mind, which is an abstract simplification of reality, trust me consciousness and being sentient is weird in magitheory.” she
  stopped herself from rambling, “Sorry I’m rambling, what I’m saying is, _you_, your
  _mind_, your _consciousness_, whatever you want, contains an _image_ a map of
  your ideal body, influencing all your choices.
  If your body isn’t synchronised
  with your internal image then it causes the _magical internal-external body
  desynchronisation syndrome_ better known as _Gender Dysphoria_ or _Body
  Dysmorphia_.”

  Ophelie needed a minute, or ten, to comprehend what Clara just _dumped_ on
  her. _Body maps_. _Internal images_. _Gender Dysphoria_ and _Body Dysmorphia_.
  She was utterly lost and her head was spinning faster than the Earth.

  Clara just _picked_ her friend up, hugged her completely, and petted her,
  until she calmed down. It took a few more minutes before the witch continued
  “Sorry for dumping all of this information on you, the bottom line is, I get it,
  I saw my parents help a lot of trans folx too, so I can help you."

  #middle

  They started their movie night, to make some time for Ophelie to make up her
  mind. They were on their second movie, the _2034_ remake of a
  sappy sapphic film, they were both transfixed as the love interest and the
  main character were approaching each other.

  Ophelie lay entirely on Clara’s body, not that the weight was a problem for
  Clara - she was pretty light and small. They were both eating some popcorn
  and unbeknown to them they both _really_ wanted to kiss the other. But for now,
  they were cuddling and munching some popcorn.

  Clara giggled suddenly, “What?” Ophelie said, waking up from a light slumber,
  her friend was _comfortable_.

  Clara smirked “Nothing ba- Ophelie, you’re really cute. I was lightly
  monitoring your stress levels with you know _magic_ and I see they are much
  better now. Are you ready to decide?” She finished smiling at her small
  friend.

  Ophelie blushed, “Will-” she tried, “Will you see my, well, my _internal
  image_?” she finished, her face a deep crimson.

  Clara laughed out loud, like, really she laughed like her life depended on it.
  “Honey, _I_ am the one making the spell, if I can’t see your internal image
  how would I be able to pull it?” she smirked, sending flutters down Ophelie’s
  stomach.

  With a tiny, high, voice the latter consented to the spell. Clara looked
  deeply into Ophelie’s eyes, conveying _raw feelings_ over a non-existent link
  but somehow she understood and nodded.

  #v(1fr)

  _The spell finished with Clara kissing her._
]


= Epilogue : Love <love>

#[

  “Ophelie! Faster you incompetent lesbian! Violet is expecting us in less than
  half an hour!” Clara yelled, through the door of their bedroom.

  Two years had passed since Ophelie came out to Clara, and for her, every one of
  these days was a blessing. She loved her body, which was _remarkably_ similar
  to her old one, minus some plus other. Which was also a blessing, it was
  easier to explain and Clara was _very eager_ at the thought of staying in
  the magical closet.

  Her _gender dysphoria_ almost completely disappeared a few weeks into her new
  life. Her grades significantly improved - enough that the professors inquired to determine if she had cheated or not, fortunately, their concerns
  were short-lived.

  She opened their bedroom door - under threat of magical pick-locking - and
  saw Clara _not so_ patiently waiting. They moved _together_ into a proper apartment at
  the end of their last semester, people were _saying things_ in the dorms and
  they kept pushing the limits of their RA’s patience before moving out.

  The apartment in itself was great, the kitchen was big and in an open space
  with the living room, with a great view of _Lake Superior_ by the big window.

  _Yeah_, they were attending university in Northern Europe and living in Canada,
  turns out things could get _fun_ when you wielded more magic than the rest of
  humanity combined. Clara teleported them to Uni every day.

  It had only _one bedroom_ with _one bed_ though. Clara enjoyed her time
  _devouring_ Ophelie’s quiet screams and fears when they first moved in, she
  hadn’t been told the _whole story_.

  “How do I look?” Ophelie said, anxiously, performing a little three hundred
  and sixty degrees turn in front of her. Even after two years in her dream body
  and with her dream girlfriend she was anxious.

  “Babe. You look absolutely _fantastic_” Clara told her, word by word, with a
  _big grin_. She came closer and kissed her girlfriend. “Seriously, you’re
  stunning, I would kill to look as cute in a dress, alas I shall be confined to
  flannel shirts and coveralls,” she said, with mock sadness.

  Ophelie rolled her eyes, she was used to her girlfriend’s demeanour nowadays.
  She opened her mouth and smiled at the same time, which produced a fun sound,
  something like a squeak, had she been on text messages she would have
  key-smashed herself into oblivion. Instead, they kissed.

  They *looked* at each other for another ten minutes, before Clara snapped out
  of her gay heaven and said “Ophelie! We need to go! I know we go there by
  teleportation but if we fool around we’ll _definitely_ be late” she said while
  extracting herself out of the knot of limbs that happened every time they
  kissed.

  #middle

  Violet waved to the two of them when they appeared back in Europe, not far
  from another lake, they hadn’t bothered to know its name, they just travelled
  the last two hundred metres or so before stopping by Violet’s door.

  She opened it, revealing the small over-crowded student apartment ready for
  their weekly film meetup. They hadn’t let the habit die out, they, instead,
  invited more friends, unfortunately, _they couldn’t teleport_ so they had
  to come here to Violet’s small apartment instead of using theirs.

  Ophelie had not even one idea about how Clara was able to afford the
  exorbitant rent of their apartment, she knew she wasn’t owning it and was
  renting it but that’s as far as she asked. Clara didn’t always answer when
  it came to magic, it was a secret she guessed.

  Violet greeted them “Hello you two” she giggled “You look wonderful, our power
  couple!” she said laughing. The older student - still under twenty-five years
  old - had started calling them _“her power couple”_ when she took them under
  her care.

  #middle

  In the room in front of the modest screen was a large sofa with everyone piled
  on it, forced to cuddle in every direction, _not that she minded_.

  Jim and his partner were old high school friends of Clara. They attended the
  University of Western Europe along with Violet and her girlfriend. They were both
  trans men, Violet was a nonbinary demi girl, her girlfriend was genderqueer,
  and Clara was the only cis person on this couch.

  She had helped them too. Although not exactly like she helped her best friend,
  she couldn’t reveal her identity to this many people. So she quietly helped
  them, over several months, every week, barring a couple of weeks
  here and there so as not to seem too suspicious.

  “What do you want to watch?” Violet, the oldest person in the room asked, and
  chaos followed.

  She managed to calm down the crowd and Ophelie managed to talk. “I took this
  2036 Disney, it’s _The Revenge of the Jedi-Mummies versus the Mighty Avengers_
  and despite its name, was set inside _the Matrix_‘s universe." Disney tried
  anything before falling over its weight a few years after that film.

  #middle

  A few days later, on break, Ophelie was walking in the busy streets of
  Toronto - Clara had given her a “lift” - and wondered what to buy for Clara.
  Valentine’s Day was the week after, and even if it was an old tradition which
  fell out of favour due to its ties with capitalism and the decaying of society
  before the Unification, she liked it.

  She ended up buying a nice necklace, it was a piece of rose gold with a flower
  - an actual flower, freeze-dried then crystallo-metalized, and hung on the
  necklace. She was pretty proud of herself for finding it out.

  She thought of buying an engagement ring. The practice of weddings was also
  very last decade but she liked the idea of being Clara’s wife. She decided to
  wait another year before asking, she still wasn’t sure Clara loved her _this
  much_.

  #middle

  But she did.
  It was Valentine’s Day, they were both dressed to the nine and Clara cooked an
  amazing dinner for the two of them. They didn’t feel like eating out.

  Then came the moment of the gift exchange. Clara smiled at her girlfriend,
  and offered Ophelie to start.

  She stood up, untied the bow and clasped the necklace over Clara’s neck.
  “It’s beautiful,” the latter said, lightly smiling, she kissed Ophelie, a nice,
  very chaste kiss relative to the setting. “Ophelie, I will offer you
  something. I want you to know you can refuse, I won’t take it personally, and
  we’ll stay girlfriends” Clara said, she was, for once, the _anxious_ one.

  Ophelie raised an eyebrow and gestured for her to continue. Clara took something
  from her pocket - even now in 2059 dresses _still_ didn’t come with pockets!
  She would be a bit jealous, but she _loved_ the feeling of dresses.

  Clara took Ophelie’s hands in hers. “Ophelie”, she smiled, “Ophelie, I can’t
  express how much I love you.”. “But I’ll try anyway, you’re wonderful, you’re
  smart, you’re resourceful, your energy is incredible to see and it has been a
  joy and honour to see you thrive these past two years.”

  Clara dropped to one knee. Ophelie’s heart started beating faster than it ever
  had.

  “Ophelie, my love, would you marry me?” _That’s it_ she was crying, big fat
  sobs fell from her eyes. Clara tried to speak, tried to get up, she was
  getting anxious. Ophelie just pushed her right on her knee gently.

  Ophelie stopped weeping, regained her composure, and said two words.

  #v(1fr)

  _“I do.”_

  #c((
    align.with(center),
    emph,
    strong,
    text.with(size: 14pt),
  ))[The End]
]
