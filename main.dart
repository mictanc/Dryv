// App.js
// Reboot (Quittr Rival) — Dark Themed Expo + React Native starter
// Drop this single file into a new Expo project and run with `npx expo start`.
// Mirrors the Flutter scaffold: Onboarding → Auth → Dashboard (+ Panic / Urge), Learn, Community, Insights, Settings.

import React, { useEffect, useMemo, useRef, useState } from 'react';
import { Alert, FlatList, SafeAreaView, ScrollView, StatusBar, StyleSheet, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { NavigationContainer, DefaultTheme, DarkTheme } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Ionicons, MaterialIcons } from '@expo/vector-icons';

// -----------------------------
// THEME (parity with Flutter colors)
// -----------------------------
const COLORS = {
  bg: '#0B0F10',
  surface: '#101417',
  card: '#151A1F',
  border: '#1F272D',
  primary: '#22D3EE',
  primaryMuted: '#0EA5B7',
  success: '#10B981',
  warning: '#F59E0B',
  danger: '#EF4444',
  text: '#E5E7EB',
  textDim: '#9CA3AF',
};

const navTheme = {
  ...DarkTheme,
  colors: {
    ...DarkTheme.colors,
    background: COLORS.bg,
    card: COLORS.bg,
    border: COLORS.border,
    text: COLORS.text,
    primary: COLORS.primary,
  },
};

// -----------------------------
// SHARED UI PRIMITIVES
// -----------------------------
const Screen = ({ children, style }) => (
  <SafeAreaView style={[styles.screen, style]}> 
    <StatusBar barStyle="light-content" />
    {children}
  </SafeAreaView>
);

const Card = ({ children, style }) => (
  <View style={[styles.card, style]}>{children}</View>
);

const Divider = () => <View style={{ height: 12 }} />;

const Pill = ({ icon, text, color }) => (
  <View style={[styles.pill, { backgroundColor: (color || COLORS.card) + '99', borderColor: COLORS.border }] }>
    <Ionicons name={icon} size={14} color={COLORS.text} />
    <View style={{ width: 6 }} />
    <Text style={styles.text}>{text}</Text>
  </View>
);

const Button = ({ title, onPress, kind = 'filled', left }) => {
  const filled = kind === 'filled';
  return (
    <TouchableOpacity onPress={onPress} activeOpacity={0.85} style={[styles.btn, filled ? { backgroundColor: COLORS.primary } : { borderWidth: 1, borderColor: COLORS.border }]}>
      <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
        {left ? <View style={{ marginRight: 8 }}>{left}</View> : null}
        <Text style={[styles.btnText, filled ? { color: '#000' } : { color: COLORS.text }]}>{title}</Text>
      </View>
    </TouchableOpacity>
  );
};

// -----------------------------
// NAVIGATION SETUP
// -----------------------------
const Stack = createNativeStackNavigator();
const Tabs = createBottomTabNavigator();

function MainTabs() {
  return (
    <Tabs.Navigator
      screenOptions={({ route }) => ({
        headerStyle: { backgroundColor: COLORS.bg },
        headerTitleStyle: { color: COLORS.text, fontWeight: '700' },
        tabBarStyle: { backgroundColor: '#0D1215', borderTopColor: COLORS.border },
        tabBarActiveTintColor: COLORS.primary,
        tabBarInactiveTintColor: COLORS.textDim,
        tabBarIcon: ({ color, size, focused }) => {
          const map = {
            Home: focused ? 'home' : 'home-outline',
            Learn: focused ? 'book' : 'book-outline',
            Community: focused ? 'chatbubbles' : 'chatbubbles-outline',
            Insights: focused ? 'trending-up' : 'trending-up-outline',
            Settings: focused ? 'settings' : 'settings-outline',
          };
          return <Ionicons name={map[route.name]} size={size} color={color} />;
        },
      })}
    >
      <Tabs.Screen name="Home" component={DashboardScreen} options={{ title: 'Reboot', headerRight: () => (
        <TouchableOpacity onPress={(navRef?.current?.navigate) ? () => navRef.current.navigate('Panic') : undefined}>
          <Ionicons name="alert" size={22} color={COLORS.text} />
        </TouchableOpacity>
      )}} />
      <Tabs.Screen name="Learn" component={LearnScreen} />
      <Tabs.Screen name="Community" component={CommunityScreen} />
      <Tabs.Screen name="Insights" component={AnalyticsScreen} />
      <Tabs.Screen name="Settings" component={SettingsScreen} />
    </Tabs.Navigator>
  );
}

const navRef = React.createRef();

export default function App() {
  return (
    <NavigationContainer theme={navTheme} ref={navRef}>
      <Stack.Navigator screenOptions={{ headerStyle: { backgroundColor: COLORS.bg }, headerTintColor: COLORS.text, headerTitleStyle: { color: COLORS.text, fontWeight: '700' } }}>
        <Stack.Screen name="Onboarding" component={OnboardingScreen} options={{ headerShown: false }} />
        <Stack.Screen name="Auth" component={AuthScreen} options={{ title: 'Create account' }} />
        <Stack.Screen name="Main" component={MainTabs} options={{ headerShown: false }} />
        <Stack.Screen name="Panic" component={PanicScreen} />
        <Stack.Screen name="Urge" component={UrgeFlowScreen} options={{ title: 'Handle an urge' }} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}

// -----------------------------
// 1) ONBOARDING
// -----------------------------
function OnboardingScreen({ navigation }) {
  const pages = [
    { title: 'Regain control', body: 'A structured 90‑day reboot that helps you quit porn and rebuild focus.' },
    { title: 'Tools for urges', body: 'Tap PANIC for grounding, breathing and instant accountability.' },
    { title: 'Anonymous community', body: 'Share progress safely with people on the same journey.' },
  ];

  const [index, setIndex] = useState(0);
  const scrollRef = useRef(null);

  return (
    <Screen>
      <ScrollView horizontal pagingEnabled showsHorizontalScrollIndicator={false} ref={scrollRef} onScroll={(e) => {
        const i = Math.round(e.nativeEvent.contentOffset.x / e.nativeEvent.layoutMeasurement.width);
        if (i !== index) setIndex(i);
      }} scrollEventThrottle={16}>
        {pages.map((p, i) => (
          <View key={i} style={{ width: '100%', padding: 24 }}>
            <View style={{ height: 48 }} />
            <Text style={styles.h1}>{p.title}</Text>
            <View style={{ height: 12 }} />
            <Text style={styles.bodyDim}>{p.body}</Text>
            <View style={{ flex: 1 }} />
            <View style={{ flexDirection: 'row', marginBottom: 24 }}>
              <Pill icon="calendar" text="90‑day plan" />
              <View style={{ width: 8 }} />
              <Pill icon="alert" text="Panic button" />
              <View style={{ width: 8 }} />
              <Pill icon="lock-closed" text="Anonymous" />
            </View>
          </View>
        ))}
      </ScrollView>
      <View style={{ flexDirection: 'row', alignItems: 'center', padding: 16 }}>
        <View style={{ flexDirection: 'row' }}>
          {pages.map((_, i) => (
            <View key={i} style={[styles.dot, index === i ? { width: 18, backgroundColor: COLORS.primary } : { backgroundColor: COLORS.border }]} />
          ))}
        </View>
        <View style={{ flex: 1 }} />
        <Button title="Get started" onPress={() => navigation.replace('Auth')} />
      </View>
    </Screen>
  );
}

// -----------------------------
// 2) AUTH (email / code — local stub)
// -----------------------------
function AuthScreen({ navigation }) {
  const [sent, setSent] = useState(false);
  const [email, setEmail] = useState('');
  const [code, setCode] = useState('');

  return (
    <Screen>
      <ScrollView contentContainerStyle={{ padding: 16 }}>
        <Text style={styles.bodyDim}>Anonymous by default. We never show your name in community.</Text>
        <View style={{ height: 16 }} />
        <TextInput style={styles.input} placeholder="Email or phone" placeholderTextColor={COLORS.textDim} value={email} onChangeText={setEmail} />
        {sent && (<>
          <View style={{ height: 12 }} />
          <TextInput style={styles.input} placeholder="One‑time code" placeholderTextColor={COLORS.textDim} value={code} onChangeText={setCode} />
        </>)}
        <View style={{ height: 16 }} />
        <View style={{ flexDirection: 'row' }}>
          <View style={{ flex: 1 }}>
            <Button title={sent ? 'Verify' : 'Send code'} onPress={() => {
              if (!sent) setSent(true); else navigation.replace('Main');
            }} />
          </View>
          <View style={{ width: 12 }} />
          <TouchableOpacity onPress={() => navigation.replace('Main')}>
            <Text style={[styles.text, { color: COLORS.text }]}>Skip for now</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </Screen>
  );
}

// -----------------------------
// 3) DASHBOARD
// -----------------------------
function DashboardScreen({ navigation }) {
  return (
    <Screen>
      <ScrollView contentContainerStyle={{ padding: 16 }}>
        <StreakHeader days={7} target={90} />
        <Divider />
        <QuickActions onPanic={() => navigation.navigate('Panic')} onUrge={() => navigation.navigate('Urge')} onLearn={() => navigation.getParent()?.navigate('Learn')} onPost={() => navigation.getParent()?.navigate('Community')} />
        <Divider />
        <TodayTasks />
        <Divider />
        <LifeTreeCard progress={0.23} />
      </ScrollView>
    </Screen>
  );
}

const StreakHeader = ({ days, target }) => (
  <Card>
    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
      <Dial progress={days / target} label={`${days} d`} />
      <View style={{ width: 16 }} />
      <View style={{ flex: 1 }}>
        <Text style={styles.bodyDim}>Current streak</Text>
        <Text style={styles.h2}>{days} days</Text>
        <View style={{ height: 8 }} />
        <Progress value={days / target} />
        <View style={{ height: 8 }} />
        <Text style={styles.bodyDim}>Goal: {target} days</Text>
      </View>
    </View>
  </Card>
);

const QuickActions = ({ onPanic, onUrge, onLearn, onPost }) => (
  <View style={{ flexDirection: 'row' }}>
    <QA icon="alert" label="Panic" onPress={onPanic} />
    <QA icon="flash" label="Urge" onPress={onUrge} />
    <QA icon="book" label="Learn" onPress={onLearn} />
    <QA icon="chatbubbles" label="Post" onPress={onPost} last />
  </View>
);

const QA = ({ icon, label, onPress, last }) => (
  <TouchableOpacity onPress={onPress} activeOpacity={0.85} style={[styles.qa, !last && { marginRight: 12 }]}>
    <Ionicons name={icon} size={20} color={COLORS.text} />
    <View style={{ height: 6 }} />
    <Text style={styles.text}>{label}</Text>
  </TouchableOpacity>
);

const TodayTasks = () => (
  <Card>
    <Text style={styles.h3}>Today’s plan</Text>
    <View style={{ height: 8 }} />
    <TaskTile text="10‑min walk (dopamine reset)" />
    <TaskTile text="Watch: How urges work (5m)" />
    <TaskTile text="Journal: Trigger → Thought → Action" />
  </Card>
);

const TaskTile = ({ text }) => {
  const [done, setDone] = useState(false);
  return (
    <TouchableOpacity onPress={() => setDone(!done)} style={styles.taskRow}>
      <View style={[styles.checkbox, done && { backgroundColor: COLORS.primary }]} />
      <Text style={[styles.text, done && { textDecorationLine: 'line-through', color: COLORS.textDim }]}>{text}</Text>
    </TouchableOpacity>
  );
};

const LifeTreeCard = ({ progress }) => (
  <Card>
    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
      <MaterialIcons name="park" size={48} color={COLORS.text} />
      <View style={{ width: 12 }} />
      <View style={{ flex: 1 }}>
        <Text style={styles.h3}>Life Tree</Text>
        <View style={{ height: 4 }} />
        <Text style={styles.bodyDim}>Grow a tree as you complete daily habits and stay clean.</Text>
        <View style={{ height: 8 }} />
        <Progress value={progress} />
      </View>
    </View>
  </Card>
);

const Dial = ({ progress, label }) => (
  <View style={styles.dialWrap}>
    <View style={[styles.dialTrack]} />
    <View style={[styles.dialProgress, { width: 84 * progress }]} />
    <Text style={[styles.h4, { position: 'absolute' }]}>{label}</Text>
  </View>
);

const Progress = ({ value }) => (
  <View style={styles.progressTrack}>
    <View style={[styles.progressBar, { width: `${Math.max(0, Math.min(1, value)) * 100}%` }]} />
  </View>
);

// -----------------------------
// 4) PANIC — breathing + accountability stubs
// -----------------------------
function PanicScreen() {
  const [seconds, setSeconds] = useState(5);
  const [inhale, setInhale] = useState(true);
  const timerRef = useRef(null);

  const start = () => {
    if (timerRef.current) clearInterval(timerRef.current);
    setSeconds(5); setInhale(true);
    timerRef.current = setInterval(() => {
      setSeconds((s) => {
        if (s === 0) {
          setInhale((v) => !v);
          return 5;
        }
        return s - 1;
      });
    }, 1000);
  };

  useEffect(() => () => timerRef.current && clearInterval(timerRef.current), []);

  return (
    <Screen>
      <ScrollView contentContainerStyle={{ padding: 16 }}>
        <Card style={{ height: 180, alignItems: 'center', justifyContent: 'center' }}>
          <Text style={styles.bodyDim}>Self‑view placeholder (use camera preview in prod)</Text>
        </Card>
        <Divider />
        <Card>
          <View style={{ flexDirection: 'row', alignItems: 'center' }}>
            <Ionicons name="heart" size={18} color={COLORS.text} />
            <View style={{ width: 8 }} />
            <Text style={styles.h3}>5‑5 Breathing</Text>
          </View>
          <View style={{ height: 8 }} />
          <View style={{ alignItems: 'center' }}>
            <Text style={styles.h2}>{inhale ? 'Inhale' : 'Exhale'}</Text>
            <View style={{ height: 4 }} />
            <Text style={styles.h1}>{seconds}s</Text>
            <View style={{ height: 12 }} />
            <Button title="Start" onPress={start} />
          </View>
        </Card>
        <Divider />
        <Card>
          <View style={{ flexDirection: 'row', alignItems: 'center' }}>
            <Ionicons name="person" size={18} color={COLORS.text} />
            <View style={{ width: 8 }} />
            <Text style={styles.h3}>Accountability</Text>
          </View>
          <View style={{ height: 8 }} />
          <Text style={styles.bodyDim}>Tap to notify your accountability partner.</Text>
          <View style={{ height: 8 }} />
          <View style={{ flexDirection: 'row' }}>
            <View style={{ flex: 1 }}><Button title={'Send "Help"'} onPress={() => Alert.alert('Share', 'Would open WhatsApp/SMS share')} /></View>
            <View style={{ width: 8 }} />
            <View style={{ flex: 1 }}><Button title={'Add contact'} kind="outline" onPress={() => Alert.alert('Contacts', 'Would open contact picker')} /></View>
          </View>
        </Card>
      </ScrollView>
    </Screen>
  );
}

// -----------------------------
// 5) URGE FLOW — steps + 2‑min timer + journal
// -----------------------------
function UrgeFlowScreen() {
  const steps = [
    'Notice the urge. Name it without judgment.',
    'Breathe slowly. Let the wave rise and fall.',
    'Redirect: stand, drink water, walk 10 steps.',
    'Log the trigger you noticed for later.',
  ];
  const [step, setStep] = useState(0);
  const [seconds, setSeconds] = useState(120);
  const timerRef = useRef(null);
  const [text, setText] = useState('');

  const start = () => {
    if (timerRef.current) clearInterval(timerRef.current);
    setSeconds(120);
    timerRef.current = setInterval(() => setSeconds((s) => (s === 0 ? 0 : s - 1)), 1000);
  };

  useEffect(() => () => timerRef.current && clearInterval(timerRef.current), []);

  return (
    <Screen>
      <ScrollView contentContainerStyle={{ padding: 16 }}>
        <Card>
          <Text style={styles.bodyDim}>Step {step + 1} of 4</Text>
          <View style={{ height: 4 }} />
          <Text style={styles.h3}>{steps[step]}</Text>
          <View style={{ height: 8 }} />
          <Progress value={(step + 1) / 4} />
          <View style={{ height: 12 }} />
          <View style={{ flexDirection: 'row', alignItems: 'center' }}>
            <Button title="Back" kind="outline" onPress={() => step > 0 && setStep(step - 1)} />
            <View style={{ width: 8 }} />
            <Button title="Next" onPress={() => step < 3 && setStep(step + 1)} />
            <View style={{ flex: 1 }} />
            <Button title="2‑min timer" onPress={start} />
          </View>
        </Card>
        <Divider />
        {seconds < 120 && (
          <Card style={{ alignItems: 'center' }}>
            <Text style={styles.h2}>{seconds}s remaining</Text>
          </Card>
        )}
        <Divider />
        <View style={[styles.input, { height: 180 }]}> 
          <TextInput
            style={{ color: COLORS.text, flex: 1, textAlignVertical: 'top' }}
            multiline
            placeholder="Jot triggers, thoughts, actions…"
            placeholderTextColor={COLORS.textDim}
            value={text}
            onChangeText={setText}
          />
        </View>
        <View style={{ height: 12 }} />
        <Button title="Save" onPress={() => Alert.alert('Saved', 'Saved to private journal (local)')} />
      </ScrollView>
    </Screen>
  );
}

// -----------------------------
// 6) LEARN — static list
// -----------------------------
function LearnScreen() {
  const items = [
    ['Why streaks work', '5 min'],
    ['Dopamine & triggers', '8 min'],
    ['Sleep and relapse risk', '6 min'],
    ['How to disclose to a partner', '7 min'],
  ];
  return (
    <Screen>
      <FlatList
        contentContainerStyle={{ padding: 16 }}
        data={items}
        keyExtractor={(it, i) => i.toString()}
        ItemSeparatorComponent={() => <View style={{ height: 8 }} />}
        renderItem={({ item }) => (
          <TouchableOpacity activeOpacity={0.85} onPress={() => Alert.alert('Lesson', 'Would open lesson detail + video')} style={styles.listTile}>
            <Text style={styles.text}>{item[0]}</Text>
            <Text style={styles.bodyDim}>{item[1]}</Text>
            <Ionicons name="play-circle" size={22} color={COLORS.text} />
          </TouchableOpacity>
        )}
      />
    </Screen>
  );
}

// -----------------------------
// 7) COMMUNITY — anonymous posts (local mock)
// -----------------------------
function CommunityScreen() {
  const [posts, setPosts] = useState([
    { user: 'anon‑318', text: 'Day 7. Urge hit after scrolling reels. Did a cold shower instead. Feeling proud.', up: 24 },
    { user: 'anon‑552', text: 'Relapsed last night. Back on track today. Any tips for evenings?', up: 11 },
  ]);
  const [input, setInput] = useState('');

  return (
    <Screen>
      <FlatList
        style={{ flex: 1 }}
        contentContainerStyle={{ padding: 16 }}
        data={posts}
        keyExtractor={(it, i) => i.toString()}
        renderItem={({ item, index }) => (
          <Card style={{ marginBottom: 12 }}>
            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
              <View style={styles.avatar}><Ionicons name="person" size={14} color={COLORS.text} /></View>
              <View style={{ width: 8 }} />
              <Text style={styles.bodyDim}>{item.user}</Text>
              <View style={{ flex: 1 }} />
              <TouchableOpacity onPress={() => {
                const next = [...posts];
                next[index] = { ...next[index], up: next[index].up + 1 };
                setPosts(next);
              }}> 
                <Ionicons name="arrow-up" size={18} color={COLORS.text} />
              </TouchableOpacity>
              <View style={{ width: 6 }} />
              <Text style={styles.text}>{item.up}</Text>
            </View>
            <View style={{ height: 8 }} />
            <Text style={styles.text}>{item.text}</Text>
          </Card>
        )}
        ListFooterComponent={<View style={{ height: 80 }} />}
      />
      <View style={{ padding: 16, flexDirection: 'row' }}>
        <View style={[styles.input, { flex: 1 }]}> 
          <TextInput
            style={{ color: COLORS.text }}
            placeholder="Share a win or ask a question…"
            placeholderTextColor={COLORS.textDim}
            value={input}
            onChangeText={setInput}
          />
        </View>
        <View style={{ width: 8 }} />
        <TouchableOpacity onPress={() => {
          if (!input.trim()) return;
          setPosts([{ user: 'you', text: input.trim(), up: 0 }, ...posts]);
          setInput('');
        }} style={[styles.btn, { backgroundColor: COLORS.primary, width: 52, justifyContent: 'center' }]}> 
          <Ionicons name="send" size={18} color="#000" />
        </TouchableOpacity>
      </View>
    </Screen>
  );
}

// -----------------------------
// 8) ANALYTICS — counters (sparkline omitted for no extra deps)
// -----------------------------
function AnalyticsScreen() {
  return (
    <Screen>
      <ScrollView contentContainerStyle={{ padding: 16 }}>
        <Card>
          <Text style={styles.h3}>Craving intensity (last 12 days)</Text>
          <View style={{ height: 12 }} />
          <Text style={styles.bodyDim}>Sparkline placeholder (add react-native-svg later if desired).</Text>
        </Card>
        <Divider />
        <View style={{ flexDirection: 'row' }}>
          <Metric label="Clean days" value="7" />
          <View style={{ width: 12 }} />
          <Metric label="Relapses" value="0" />
          <View style={{ width: 12 }} />
          <Metric label="Breathing used" value="4" />
        </View>
      </ScrollView>
    </Screen>
  );
}

const Metric = ({ label, value }) => (
  <View style={styles.metric}> 
    <Text style={styles.h2}>{value}</Text>
    <View style={{ height: 4 }} />
    <Text style={styles.bodyDim}>{label}</Text>
  </View>
);

// -----------------------------
// 9) SETTINGS — blockers, reminders, privacy
// -----------------------------
function SettingsScreen() {
  return (
    <Screen>
      <ScrollView contentContainerStyle={{ padding: 16 }}>
        <Section title="Blockers">
          <Row onPress={() => Alert.alert('Safe‑Browse', 'Would request VPN/Accessibility service to enable DNS/URL filtering.')}
               title="Enable Safe‑Browse (Android)"
               subtitle="Blocks porn domains system‑wide. Requires a local VPN service." />
          <Row onPress={() => Alert.alert('Restricted Mode', 'Would deep‑link to YouTube settings')}
               title="YouTube restricted mode" subtitle="Open settings to enable OS‑level restriction." rightIcon="open-outline" />
        </Section>
        <Section title="Reminders">
          <Row title="Daily check‑in" subtitle="08:00 IST" rightIcon="chevron-forward" />
          <Row title="Evening reflection" subtitle="22:00 IST" rightIcon="chevron-forward" />
        </Section>
        <Section title="Privacy">
          <Row title="Anonymous in community" subtitle="ON" />
          <Row title="Export my data" rightIcon="download-outline" onPress={() => Alert.alert('Export', 'Would generate JSON export')} />
          <Row title="Delete my account" rightIcon="trash-outline" onPress={() => Alert.alert('Delete', 'GDPR‑style deletion flow')} />
        </Section>
        <Section title="About">
          <Row title="Version" subtitle="0.1.0" />
          <Row title="Made with ❤️ to help you live better." />
        </Section>
      </ScrollView>
    </Screen>
  );
}

const Section = ({ title, children }) => (
  <Card style={{ padding: 12, marginBottom: 12 }}>
    <Text style={[styles.bodyDim, { marginLeft: 4, marginBottom: 8 }]}>{title}</Text>
    {children}
  </Card>
);

const Row = ({ title, subtitle, onPress, rightIcon }) => (
  <TouchableOpacity onPress={onPress} activeOpacity={0.85} style={styles.row}> 
    <View>
      <Text style={styles.text}>{title}</Text>
      {subtitle ? <Text style={styles.bodyDim}>{subtitle}</Text> : null}
    </View>
    <View style={{ flex: 1 }} />
    {rightIcon ? <Ionicons name={rightIcon} size={18} color={COLORS.text} /> : null}
  </TouchableOpacity>
);

// -----------------------------
// STYLES
// -----------------------------
const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: COLORS.bg },
  text: { color: COLORS.text, fontSize: 14 },
  bodyDim: { color: COLORS.textDim, fontSize: 14 },
  h1: { color: COLORS.text, fontSize: 32, fontWeight: '800' },
  h2: { color: COLORS.text, fontSize: 24, fontWeight: '800' },
  h3: { color: COLORS.text, fontSize: 16, fontWeight: '700' },
  h4: { color: COLORS.text, fontSize: 16, fontWeight: '800' },
  card: { backgroundColor: COLORS.card, borderColor: COLORS.border, borderWidth: 1, borderRadius: 20, padding: 16 },
  dot: { height: 8, width: 8, marginRight: 6, borderRadius: 12 },
  btn: { paddingVertical: 12, paddingHorizontal: 18, borderRadius: 18 },
  btnText: { fontWeight: '700', letterSpacing: 0.2, fontSize: 14 },
  pill: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 12, paddingVertical: 8, borderRadius: 100, borderWidth: 1 },
  input: { backgroundColor: COLORS.surface, borderColor: COLORS.border, borderWidth: 1, borderRadius: 14, paddingHorizontal: 14, paddingVertical: 12, color: COLORS.text },
  qa: { flex: 1, height: 72, backgroundColor: COLORS.card, borderColor: COLORS.border, borderWidth: 1, borderRadius: 18, alignItems: 'center', justifyContent: 'center' },
  taskRow: { flexDirection: 'row', alignItems: 'center', paddingVertical: 10 },
  checkbox: { width: 18, height: 18, borderRadius: 4, borderWidth: 1, borderColor: COLORS.border, marginRight: 10 },
  dialWrap: { width: 84, height: 84, borderRadius: 14, backgroundColor: COLORS.surface, overflow: 'hidden', justifyContent: 'center', alignItems: 'center' },
  progressTrack: { height: 8, backgroundColor: COLORS.surface, borderRadius: 8, overflow: 'hidden', borderWidth: 1, borderColor: COLORS.border },
  progressBar: { height: 8, backgroundColor: COLORS.primary },
  listTile: { backgroundColor: COLORS.card, borderColor: COLORS.border, borderWidth: 1, borderRadius: 16, padding: 14, flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' },
  avatar: { width: 24, height: 24, borderRadius: 12, backgroundColor: COLORS.surface, alignItems: 'center', justifyContent: 'center' },
  metric: { flex: 1, backgroundColor: COLORS.card, borderColor: COLORS.border, borderWidth: 1, borderRadius: 16, padding: 16, alignItems: 'center' },
  row: { flexDirection: 'row', alignItems: 'center', paddingVertical: 12, paddingHorizontal: 8, borderTopWidth: 0, borderBottomWidth: 0 },
});
