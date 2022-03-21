
<img src="https://cdn.jsdelivr.net/gh/rse/vdon-call@master/vdon-call-logo.svg" width="300" align="right" alt=""/>

VDON Call
=========

**VDON Call** is a [WebRTC](https://en.wikipedia.org/wiki/WebRTC)/[NDI](https://ndi.tv)-based
remote caller ingest solution for live video productions, based on
the two swiss army knifes in their field: the awesome, low-latency,
P2P-based video streaming facility [VDO.Ninja](https://vdo.ninja),
and the awesome, ultra-flexible video mixing software
[OBS Studio](https://obsproject.com). An instance of the
landing page, the corresponding URL trampoline, of **VDON Call** is publically
available under the meaningful name URL [caller.studio](https://caller.studio) ("caller of the studio").

Motivation
----------

The name **VDON Call** is derived from the product
[vMix Call](https://www.vmix.com/products/vmix-call.aspx), the great but
weaker facility it can substitute in practice. The motivation and
primary killer feature of **VDON Call**, in contrast to the otherwise also
awesome vMix Call, is that the callers can ingest their camera and
content *in parallel* and without having to fiddle around with two independent
Browser tabs and that this dual-ingest approach is available for 8
callers in total instead of just 4 (because vMix Call supports a
maximum of 8 incoming video streams only). The resulting ingested video
streams are available as NDI streams on the local network and can be
easily consumed (usually on a separate computer) with a video mixing
software like vMix or OBS Studio.

Constraints
-----------

The [underlying VDO.Ninja parameterization](https://github.com/rse/vdon-call/blob/master/index.html#L368) is very opinionated and
heavily optimized for a total of 16+1 video streams, to allow one to
ingest up to 8 callers with their camera and shared content (screen or
window) into the video production and to provide a return feed from the
video production back to the callers. The callers can hear but not see
each other, except the provided return feed is some sort of multiview
and shows the callers. This is intentional, as this is not a general
video conferencing solution, but a dedicated way to ingest remote
video callers of a production. Please keep this in mind.

There are two particular bottlenecks in this approach, which are
addressed by the particular VDO.Ninja parameterization:

1. The caller receiver-side is an OBS Studio, acting as a WebRTC-to-NDI
   gateway and has to run on a medium gaming PC (Intel Core i7 11700KF,
   NVIDIA RTX 3070Ti, 32GB RAM) with just about a maximum of about 80%
   overall resource utilization. As a result, the callers camera use
   720p24 and a bitrate of 2000 kbps with H.264 and the callers content
   use 1080p6 and a bitrate of 3000 kbps with H.264.

2. The production sender-side, providing the return feed of the video
   production back to the caller, should require no more than half of
   the uplink (50 mbps) and downlink (100 mbps) of the usual Internet
   connections available in Germany. As a result, the return feed uses
   1080p29.97 and a bitrate of 3000 kbps with VP8.

Installation
------------

The solution consists of the following parts which have to be installed:

1. **URL TRAMPOLINE:**

   This is just the file [index.html](index.html), which acts as a URL trampoline, a
   tiny webpage which generates the underlying, heavily parameterized VDO.Ninja
   URLs. Install it as `index.html` to an arbitrary Internet service.
   The page without any attached parameters is usually only used
   by the video production crew to generate URLs. The page
   with attached parameters is used by all **VDON Call** components
   (see below) to expand the short URLs to the underlying VDO.Ninja URLs.
   For convenience reasons, an instance of this URL trampoline
   is publically available under the meaningful URL
   [caller.studio](https://caller.studio).

2. **WEBRTC-TO-NDI GATEWAY:**

   This is an OBS Studio instance, driven by the files [obs-studio/basic.ini](obs-studio/basic.ini),
   [obs-studio.json](obs-studio.json) and
   [obs-studio.lua](obs-studio.lua).
   These are the OBS Studio profile, scene collection and configuration update script,
   which establish OBS Studio as a WebRTC-to-NDI gateway. For this to work,
   you have to locally install the following prerequisites:

   - [NDI Tools](https://www.ndi.tv/tools/)
   - [OBS Studio](https://obsproject.com/)
   - [OBS NDI](https://github.com/Palakis/obs-ndi/)

   Then use *Profile* &rarr; *Import* for importing the
   [obs-studio/](obs-studio/) directory. Then use *Scene Collection*
   &rarr; *Import* for importing the [obs-studio.json](obs-studio.json)
   file. Then, use *Tools* &rarr; *Scripts* &rarr; `+` for importing the
   [obs-studio.lua](obs-studio.lua) file.

   Once this is done, use *Tools* &rarr; *Scripts* &rarr;
   `obs-studio.lua` to update all browser sources in OBS Studio with
   your URL trampoline information.

3. **VIDEO PRODUCTION:**

   This is the actual video production which requires a video mixing
   software like vMix or OBS Studio to consume and mix the NDI streams
   of the callers and produce a "program" (aka output) which can act
   as the return feed video stream to the callers. This really has to
   run on a computer which is separate (but in the same LAN) to the
   WebRTC-to-NDI gateway.

Components
----------

The solution consists of the following logical parts under run-time:

- **URL Trampoline**

  This is the URL trampoline which is deployed to a publically reachable
  URL like `https://caller.studio`, and which can be used by the
  production crew to easily generate the required "short" URLs based
  on unique organisation name and a room name (unique per organisation). Its
  trampoline functionality on access of these "short" URLs expand to the
  underlying, technical, heavily-parameterized VDO.Ninja URLs.

  ![](shot-1-trampoline.png)

- **Caller (Sender)**

  This is the caller sender-side, i.e., Google Chrome opened a URL
  like `https://caller.studio/#/example/example/C1`.
  The result the VDO.Ninja user interface, configured for a caller
  participating in a room where the user can only see its own camera and
  shared content preview and the return feed of the production (here
  a multiview from vMix).

  ![](shot-2-caller-sender.png)

- **Caller (Receiver)**

  This is the heart of the solution, the caller receiver-side,
  i.e., OBS Studio with the **VDON Call** profile and
  scene collection loaded which accesses URLs like
  `https://caller.studio/#/example/example/C1?stream=camera` and
  `https://caller.studio/#/example/example/C1?stream=content`. For an
  overview, a special multiview scene is in preview (and also exposed
  via NDI for inclusion into the multiview of the production -- see
  below). You can attach the optional parameters
  `cam` (camera device), `mic` (microphone device), and `spk` (speaker device)
  to the URL. An example URL would be
  `https://caller.studio/#/example/example/C1?cam=Standard&mic=Standard"

  ![](shot-3-caller-receiver.png)

- **Production (Sender)**

  This is the video production. It uses a video mixing software
  like vMix (shown here) or OBS Studio (as a decent alternative). This
  production receives all callers (and the multiview) from OBS
  Studio via NDI and mixes them into a resulting program video
  stream. For convenience reasons, beside this program video
  stream, this vMix instance also exports a multiview video stream
  which shows the caller ingest multiview, selected callers, the
  program video stream and the clock. Either the program or (as
  shown shere) the multiview video stream is then send back to the
  callers via a companion Google Chrome instance accessing the URL
  `https://caller.studio/#/example/example/A1` or
  `https://caller.studio/#/example/example/A2?mode=meshcast`.
  Similar to the `mode=meshcast`, you can attach the optional parameters
  `cam` (camera device), `mic` (microphone device), and `spk` (speaker device)
  to the URL. An example URL would be
  `https://caller.studio/#/example/example/A1?cam=vMix Video External 2&mic=Line 2 (Virtual Audio Cable)"

  ![](shot-4-production.png)

- **Director (Control)**

  This is the optional VDO.Ninja director
  view, i.e., Google Chrome accessing the URL
  `https://caller.studio/#/example/example/D1`
  where the production crew can send messages to the callers, adjust the
  parameters of the callers, etc. The director view intentionally has
  all incoming video/audio feeds disabled and also does not send an own
  outgoing video/audio feed to not cause any additional network traffic
  on the callers.

  ![](shot-5-director.png)

See Also
--------

This solution was announced 2022/03 in the following communities:

- [Reddit: VDO.Ninja](https://www.reddit.com/r/VDONinja/comments/ti8jz4/vdon_call_remote_caller_ingest_via_vdoninja_to/)
- [Reddit: OBS Studio](https://www.reddit.com/r/obs/comments/tihbxz/vdon_call_external_ndibased_remote_caller_ingest/)
- [Reddit: vMix](https://www.reddit.com/r/vmix/comments/ti8r3g/vdon_call_remote_caller_ingest_via_vdoninja_obs/)
- [vMix: vMix Call](https://forums.vmix.com/posts/t28731-VDON-Call--a-vMix-Call-substitute--when-parallel-camera-and-screen-sharing-is-required)
- [Twitter: Engelschall](https://twitter.com/engelschall/status/1505340731593998339)

Copyright & License
-------------------

Copyright &copy; 2022 [Dr. Ralf S. Engelschall](mailto:rse@engelschall.com)<br/>
Licensed under [MIT](https://spdx.org/licenses/MIT)

